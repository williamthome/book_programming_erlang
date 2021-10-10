-module(shop_total).
-export([total/1, total_v2/1]).
-import(shop, [cost/1]).
-import(loop, [sum/1, map/2]).

total(Products) ->
  sum(map(Products, fun({Product, Quantity}) -> cost(Product) * Quantity end)).

%
% First compile and import dependencies
% * Beam files must be in the same directory
%
% cd(chapter4_4_import).
% c("../chapter4_2_shop/shop").
% c("../chapter4_3_loop/loop").
% c(shop_total).
%
% Run the program
%
% shop_total:total([{orange, 5}]).
% 25
%

total_v2(Products) ->
  sum([cost(Product) * Quantity || {Product, Quantity} <- Products]).