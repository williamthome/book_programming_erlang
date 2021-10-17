-module(beer_shop_customer).
-behaviour(gen_server).
-export([start_link/1, drink/3, consumed/1]).
-export([init/1, handle_cast/2, handle_call/3]).

%% Client

start_link(CustomerName) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, CustomerName, []).

drink(Customer, Shop, Quantity) when is_pid(Customer) ->
  gen_server:cast(Customer, {drink, Shop, Quantity}).

consumed(Customer) when is_pid(Customer) ->
  gen_server:call(Customer, consumed).

%% Server

init(CustomerName) ->
  BeerConsumed = 0,
  {ok, {CustomerName, BeerConsumed}}.

handle_cast({drink, Shop, Quantity}, {CustomerName, BeerConsumed})
  when is_pid(Shop), Quantity > 1 ->
    beer_shop:consume(Shop, self(), Quantity),
    io:format("~p says: Give me ~p beers!~n", [CustomerName, Quantity]),
    {noreply, {CustomerName, BeerConsumed + Quantity}}.

handle_call(consumed, _From, {CustomerName, BeerConsumed} = Customer) ->
  io:format("~p says: I drank ~p beers :|~n", [CustomerName, BeerConsumed]),
  {reply, BeerConsumed, Customer}.
