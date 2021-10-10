-module(my_geometry).

-export([test/0, area/1]).

test() ->
  12 = area({rectangle, 3, 4}),
  16 = area({square, 4}),
  tests_worked.

area({rectangle, Width, Height}) ->
  Width * Height;
area({square, Side}) ->
  Side * Side;
area({circle, Radius}) ->
  math:pi() * Radius * Radius.
