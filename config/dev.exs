use Mix.Config

config :authable, Authable.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "mustafaturan",
  password: "postgres",
  database: "authable_dev",
  hostname: "localhost",
  pool_size: 10
