# Authable

OAuth2 Provider implementation modules and helpers using `ecto` and `postgress` for any `elixir` application.

## Installation

The package can be installed as:

  1. Add authable to your list of dependencies in `mix.exs`:

        def deps do
          [{:authable, "~> 0.3.1"}]
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
            authorization_code: Authable.AuthorizationCodeGrantType,
            client_credentials: Authable.ClientCredentialsGrantType,
            password: Authable.PasswordGrantType,
            refresh_token: Authable.RefreshTokenGrantType
          },
          scopes: ~w(read write session)

  - If you want to disable a strategy then delete from strategies config.

  - If you want to add a new strategy then add your own module with
  authorize(params) functions and return a Authable.Token struct.

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
