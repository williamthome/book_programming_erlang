-module(hello_world).
-export([init/2]).

init(Req, Opts) ->
  Req2 = cowboy_req:reply(
    200,
    #{<<"content-type">> => <<"text/plain; charset=utf-8">>},
    <<"Hello, World!">>,
    Req
  ),
  {ok, Req2, Opts}.
