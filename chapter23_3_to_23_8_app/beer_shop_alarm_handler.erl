-module(beer_shop_alarm_handler).
-behaviour(gen_event).
-export([init/1, handle_event/2, handle_call/2]).

init(Args) ->
  io:format("beer_shop_alarm_handler init: ~p~n", [Args]),
  N = 0,
  {ok, N}.

handle_event({set_alarm, out_of_stock}, N) ->
  error_logger:error_msg("*** Tell the someone to buy more beer!~n"),
  {ok, N+1};

handle_event({clear_alarm, out_of_stock}, N) ->
  error_logger:error_msg( "*** Danger over. We have beer o/~n"),
  {ok, N};

handle_event(Event, N) ->
  io:format("*** unmatched event: ~p~n", [Event]),
  {ok, N}.

handle_call(_Request, N) ->
  Reply = N,
  {ok, Reply, N}.
