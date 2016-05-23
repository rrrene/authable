use Mix.Config

config :authable, Authable.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "mustafaturan",
  password: "postgres",
  database: "authable_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
