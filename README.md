# Authable

OAuth2 Provider implementation objects and helpers using `ecto` and `postgress` for any `elixir` application.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add authable to your list of dependencies in `mix.exs`:

        def deps do
          [{:authable, "~> 0.1.0"}]
        end

  2. Ensure authable is started before your application:

        def application do
          [applications: [:authable]]
        end

  3. Add authable configurations to your `config/config.exs` file:

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

  4. Add database configurations for the `Authable.Repo` on env config files:

        config :authable, Authable.Repo,
          adapter: Ecto.Adapters.Postgres,
          username: "",
          password: "",
          database: "",
          hostname: "",
          pool_size: 10

  5. Run migrations for Authable.Repo:

        mix ecto.migrate -r Authable.Repo

  6. You are ready to go!
