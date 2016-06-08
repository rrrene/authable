use Mix.Config

config :authable, Authable.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env["DATABASE_POSTGRESQL_USERNAME"] || "postgres",
  password: System.get_env["DATABASE_POSTGRESQL_PASSWORD"] || "",
  database: "authable_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
