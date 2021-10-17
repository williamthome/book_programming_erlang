-module(beer_shop).
-behaviour(gen_server).
-export([start_link/2, consume/3, add_beer/2]).
-export([init/1, handle_cast/2, handle_call/3]).

%% Client

start_link(ShopName, BeerStock)
  when is_integer(BeerStock), BeerStock >= 0 ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, {ShopName, BeerStock}, []).

consume(Shop, Customer, Quantity) when is_pid(Shop) ->
  gen_server:cast(Shop, {consume, Customer, Quantity}).

add_beer(Shop, Quantity) when is_pid(Shop) ->
  gen_server:call(Shop, {add_beer, Quantity}).

%% Server

init(Shop) ->
  {ok, Shop}.

handle_cast({consume, Customer, Quantity}, {ShopName, BeerStock})
  when is_pid(Customer), Quantity > 1 ->
    io:format("~p says: Take your ~p beers ~p o/~n", [ShopName, Quantity, Customer]),
    NewStock = max(0, BeerStock - Quantity),
    may_be_out_of_stock(NewStock),
    {noreply, {ShopName, NewStock}}.

handle_call({add_beer, Quantity}, _From, {ShopName, BeerStock}) ->
  NewStock = Quantity + BeerStock,
  io:format("~p new stock: ~p~n", [ShopName, NewStock]),
  {reply, {ok, NewStock}, {ShopName, NewStock}}.

% Server / Helpers

may_be_out_of_stock(0) ->
  alarm_handler:set_alarm(out_of_stock),
  io:format("Out of stock! Adding beer...~n"),
  Self = self(),
  spawn(fun() -> add_beer(Self, 100) end),
  % add_beer(Self, 100), % timeout error
  alarm_handler:clear_alarm(out_of_stock),
  true;

may_be_out_of_stock(_) ->
  false.
