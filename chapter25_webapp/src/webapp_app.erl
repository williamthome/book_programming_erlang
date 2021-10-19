%%%-------------------------------------------------------------------
%% @doc webapp public API
%% @end
%%%-------------------------------------------------------------------

-module(webapp_app).

-behaviour(application).

-export([start/2, stop/1]).

-define(ANY_HOST, '_').
-define(NO_OPTIONS, []).

start(_StartType, _StartArgs) ->
  Routes = [
    {"/", cowboy_static, {priv_file, webapp, "index.html"}},
    {"/hello", hello_world, ?NO_OPTIONS}
  ],
  Dispatch = cowboy_router:compile([{?ANY_HOST, Routes}]),

  Port = 2938,
  TransOpts = [ {ip, {0,0,0,0}}, {port, Port} ],
  ProtoOpts = #{env => #{dispatch => Dispatch}},

  {ok, _CowboyPid} = cowboy:start_clear(webapp,
    TransOpts, ProtoOpts),

  io:format("Server running at http://localhost:~p~n", [Port]),

  webapp_sup:start_link().

stop(_State) ->
  ok.

%% internal functions
