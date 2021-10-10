-module(loop).
-export([test/0, for/3, map/2, sum/1]).

test() ->
  test_for(),
  test_map(),
  test_sum().

test_for() ->
  [1,2,3,4,5,6,7,8,9,10] = for(1, 10, fun(I) -> I end),
  erlang:display(for_tests_works).

for(Max, Max, Fn) -> [Fn(Max)];
for(I, Max, Fn) -> [Fn(I) | for(I+1, Max, Fn)].

test_map() ->
  [1,4,9,16,25,36,49,64,81,100] = map([1,2,3,4,5,6,7,8,9,10], fun(I) -> I*I end),
  erlang:display(map_tests_works).

map([Last], Fn) -> [Fn(Last)];
map([Head | Tail], Fn) -> [Fn(Head) | map(Tail, Fn)].

test_sum() ->
  10 = sum([1,2,3,4]),
  erlang:display(sum_tests_works).

sum(List) -> sum(List, 0).
sum([Last], Acc) -> Last + Acc;
sum([Head | Tail], Acc) -> sum(Tail, Head + Acc).
