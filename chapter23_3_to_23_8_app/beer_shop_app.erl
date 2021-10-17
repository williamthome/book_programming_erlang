-module(beer_shop_app).
-behaviour(application).
-export([start/2, stop/1]).

start(Type, Args) ->
  io:format("beer_shop_app start: ~p~n", [{Type, Args}]),
  beer_shop_supervisor:start_link(Args).

stop(State) ->
  io:format("beer_shop_app stop: ~p~n", [State]),
  ok.
