-module(error_handling).
-export([handle/1, output/0]).

gen_exception(1) -> a;
gen_exception(2) -> throw(a);
gen_exception(3) -> exit(a);
gen_exception(4) -> {'EXIT', a};
gen_exception(5) -> error(a).

-define(VALID_VALUES, [1,2,3,4,5]).

handle(Value) ->
  case lists:member(Value, ?VALID_VALUES) of
    true -> do_handle(Value);
    false -> {error, "Enter a valid value", ?VALID_VALUES}
  end.

do_handle(Value) ->
  try gen_exception(Value) of
    Result -> {Value, normal, Result}
  catch
    throw:Err -> {Value, caught, thrown, Err};
    exit:Err -> {Value, caught, exited, Err};
    error:Err -> {Value, caught, error, Err}
    % _:Err -> {Mod,Func,Arity,Info}
  end.

output() ->
  [{I, (catch gen_exception(I))} || I <- ?VALID_VALUES].