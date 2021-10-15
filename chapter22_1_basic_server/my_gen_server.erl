-module(my_gen_server).
-export([start/1, start/2, rpc/2]).

start(Module) ->
  start(Module, Module).

start(Name, Module) ->
  register(Name, spawn(fun() -> loop(Name, Module, Module:init()) end)).

rpc(Name, Request) ->
  Name ! {self(), Request},
  receive
    {Name, Response} ->
      Response
  end.

loop(Name, Module, OldState) ->
  receive
    {From, Request} ->
      try Module:handle(Request, OldState) of
        {Response, NewState} ->
          From ! {Name, Response},
          loop(Name, Module, NewState)
      catch
        _:Why ->
          log_error(Name, Request, Why),
          From ! {Name, crash},
          loop(Name, Module, OldState)
      end
  end.

log_error(Name, Request, Why) ->
  io:format("Server ~p request ~p~n"
            "caused exception ~p~n",
            [Name, Request, Why]).
