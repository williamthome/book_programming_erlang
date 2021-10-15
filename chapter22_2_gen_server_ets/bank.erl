-module(bank).
-behaviour(gen_server).
-export([
  test/0, start_link/0,
  new_account/1, delete_account/1, deposit/2, withdraw/2
]).
-export([
  init/1, handle_call/3, handle_cast/2, terminate/2,
  handle_info/2, code_change/3
]).
-include_lib("stdlib/include/ms_transform.hrl"). % overrides ets:fun2ms(SomeLiteralFun). See https://learnyousomeerlang.com/ets#the-concepts-of-ets
-define(SERVER, ?MODULE).

%% Test

test() ->
  start_link(),
  Owner = william,
  {ok, Owner} = new_account(Owner),
  {ok, {Owner, 10}} = deposit(Owner, 10),
  {ok, {Owner, 0}} = withdraw(Owner, 10),
  {ok, Owner} = delete_account(Owner),
  ok.

%% Client

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

new_account(Owner) ->
  gen_server:call(?MODULE, {new_account, Owner, 0}).

delete_account(Owner) ->
  gen_server:call(?MODULE, {delete_account, Owner}).

deposit(Owner, Amount) ->
  gen_server:call(?MODULE, {deposit, Owner, Amount}).

withdraw(Owner, Amount) ->
  gen_server:call(?MODULE, {withdraw, Owner, Amount}).

%% Server

init([]) ->
  {ok, ets:new(?MODULE, [])}.

handle_call({new_account, Owner, InitialCash}, _From, AccountsTable) ->
  Account = {Owner, InitialCash},
  Reply = case ets:insert_new(AccountsTable, Account) of
    true -> {ok, Owner};
    false -> {error, account_already_exists}
  end,
  {reply, Reply, AccountsTable};

handle_call({delete_account, Owner}, _From, AccountsTable) ->
  Account = ets:fun2ms(fun({O, _}) -> O =:= Owner end),
  Reply = case ets:select_delete(AccountsTable, Account) of
    N when N > 0 -> {ok, Owner};
    0 -> {error, account_does_not_exists}
  end,
  {reply, Reply, AccountsTable};


handle_call({deposit, Owner, Amount}, _From, AccountsTable) ->
  Reply = case ets:lookup(AccountsTable, Owner) of
    [{_, InCash}] -> update_account_cash(AccountsTable, Owner, InCash + Amount);
    [] -> {error, account_does_not_exists}
  end,
  {reply, Reply, AccountsTable};

handle_call({withdraw, Owner, Amount}, _From, AccountsTable) ->
  Reply = case ets:lookup(AccountsTable, Owner) of
    [{_, InCash}] ->
      case InCash - Amount of
        NewAmount when NewAmount >= 0 -> update_account_cash(AccountsTable, Owner, NewAmount);
        NewAmount -> {error, {insufficient_funds, NewAmount}}
      end;
    [] -> {error, account_does_not_exists}
  end,
  {reply, Reply, AccountsTable}.

terminate(_Reason, AccountsTable) ->
  ets:delete(AccountsTable),
  ok.

%% Server / Helpers

update_account_cash(AccountsTable, Owner, Amount) ->
  case ets:update_element(AccountsTable, Owner, [{2, Amount}]) of
    true -> {ok, {Owner, Amount}};
    false -> {error, unknown_error}
  end.

%% Server / Not implemented

handle_cast(_Msg, State) ->
  Return = {noreply, State},
  io:format("handle_cast: ~p~n", [Return]),
  Return.

handle_info(_Info, State) ->
  Return = {noreply, State},
  io:format("handle_info: ~p~n", [Return]),
  Return.

code_change(_OldVsn, State, _Extra) ->
  Return = {ok, State},
  io:format("code_change: ~p~n", [Return]),
  Return.
