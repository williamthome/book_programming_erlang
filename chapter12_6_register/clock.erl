-module(clock).
-export([start/2, stop/0]).

%% Register the clock process

%% e.g.
%%
%% start:
%% clock:start(1000, fun() -> io:format("TICK ~p~n",[erlang:now()]) end).
%%
%% stop:
%% clock:stop().

start(Time, Fun) ->
  register(clock, spawn(fun() -> tick(Time, Fun) end)).

stop() ->
  clock ! stop.

tick(Time, Fun) ->
  receive
    stop ->
      Fun()
  after Time ->
    Fun(),
    tick(Time, Fun)
  end.
