{application, beer_shop,
 [
  {description, "An Erlang app for learn purposes"},
  {vsn, "1.0"},
  {modules, [
              beer_shop_app,
              beer_shop,
              beer_shop_customer,
              beer_shop_supervisor,
              beer_shop_alarm_handler
            ]},
  {registered, [beer_shop, beer_shop_customer]},
  {applications, [
                  kernel,
                  stdlib
                 ]},
  {env, []},
  {mod, {beer_shop_app, []}},
  {start_phases, []}
 ]
}.
