-module(beer_shop_supervisor).
-behaviour(supervisor).
-export([start_link/1, init/1]).

start_link(Args) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init(Args) ->
  gen_event:swap_handler(alarm_handler,
    {alarm_handler, swap},
    {beer_shop_alarm_handler, args}
  ),
  Opts = #{
    strategy => one_for_one,
    intensity => 3,
    period => 10,
    auto_shutdown => never
  },
  Childrens = [],
  io:format("beer_shop_supervisor init: ~p~n", [Args]),
  {ok, {Opts, Childrens}}.
