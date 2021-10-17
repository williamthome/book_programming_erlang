#!/bin/sh

erlc beer_shop_alarm_handler.erl \
  beer_shop_supervisor.erl \
  beer_shop_customer.erl \
  beer_shop.erl \
  beer_shop_app.erl

erl -boot start_sasl \
  -config sys \
  -eval "application:load(beer_shop), application:start(beer_shop)."
