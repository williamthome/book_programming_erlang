# Beer Shop

Run the app:

```
./beer_shop.sh
```

Copy and paste this commands to the erl console:

```erlang
{ok, Shop} = beer_shop:start_link(my_shop, 5),
{ok, Customer} = beer_shop_customer:start_link(joao_kleber),
beer_shop_customer:drink(Customer, Shop, 5).
```

Output:

```
joao_kleber says: Give me 5 beers!
my_shop says: Take your 5 beers <0.97.0> o/
```

Then check the `error.log` file:

```log
=ERROR REPORT==== 18-Oct-2021::23:33:59.873587 ===
*** Tell the someone to buy more beer!

=ERROR REPORT==== 18-Oct-2021::23:33:59.874019 ===
*** Danger over. We have beer o/
```
