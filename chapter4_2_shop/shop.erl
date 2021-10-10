-module(shop).

-export([test/0, cost/1, total/1]).

test() ->
  20 = total([{orange, 2}, {milk, 1}, {banana, 1}]),
  tests_worked.

cost(orange) -> 5;
cost(newspaper) -> 8;
cost(apple) -> 2;
cost(banana)-> 3;
cost(milk) -> 7.

total([{Product, Quantity} | Tail]) ->
  cost(Product) * Quantity + total(Tail);
total([]) ->
  0.
