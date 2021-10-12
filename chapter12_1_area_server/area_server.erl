-module(area_server).
-export([start/0, area/2, loop/0]).

start() ->
  spawn(?MODULE, loop, []).

area(Pid, What) ->
  rpc(Pid, What).

rpc(Pid, Request) ->
  Pid ! {self(), Request},
  receive
    {Pid, Response} ->
      Response
  end.

loop() ->
  receive
    {From, {rectangle, Width, Height}} ->
      From ! {self(), Width * Height},
      loop();
    {From, {square, Side}} ->
      From ! {self(), Side * Side},
      loop()
  end.
