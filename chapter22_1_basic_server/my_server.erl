-module(my_server).
-export([init/0, handle/2, all/0, add/2, find/1, delete/1, update/2]).
-import(my_gen_server, [rpc/2]).
-define(SERVER, ?MODULE).

% Client

all() ->
  rpc(?SERVER, all).

add(Food, Data) ->
  rpc(?SERVER, {add, Food, Data}).

find(Food) ->
  rpc(?SERVER, {find, Food}).

delete(Food) ->
  rpc(?SERVER, {delete, Food}).

update(Food, NewData) ->
  rpc(?SERVER, {update, Food, NewData}).

% Server

init() ->
  dict:new().

handle(all, Dict) ->
  {dict:to_list(Dict), Dict};

handle({add, Food, Data}, Dict) ->
  {ok, dict:store(Food, Data, Dict)};

handle({find, Food}, Dict) ->
  {dict:find(Food, Dict), Dict};

handle({delete, Food}, Dict) ->
  {ok, dict:erase(Food, Dict)};

handle({update, Food, NewData}, Dict) ->
  {ok, dict:update(Food, fun(_Data) -> NewData end, Dict)}.
