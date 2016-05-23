# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

config :authable,
  repo: Authable.Repo,
  resource_owner: Authable.User,
  token_store: Authable.Token,
  client: Authable.Client,
  app: Authable.App,
  expires_in: %{
    access_token: 3600,
    refresh_token: 24 * 3600,
    authorization_code: 300,
    session_token: 30 * 24 * 3600
  },
  strategies: %{
    authorization_code: true,
    client_credentials: true,
    password: true,
    refresh_token: true
  },
  scopes: ~w(read write session)

# You can configure for your application as:
#
#     config :authable, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:authable, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
if Enum.any?(~w(dev test docs)a, fn(env) -> Mix.env == env end),
do: import_config "#{Mix.env}.exs"
