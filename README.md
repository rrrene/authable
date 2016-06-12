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

  If you want to disable a strategy then delete from strategies config.

  If you want to add a new strategy then add your own module with `authorize(params)` function and return a `Authable.Token` struct.

  4. Add database configurations for the `Authable.Repo` on env config files:

        config :authable, Authable.Repo,
          adapter: Ecto.Adapters.Postgres,
          username: "",
          password: "",
          database: "",
          hostname: "",
          pool_size: 10

  5. Run migrations for Authable.Repo (Note: all id fields are UUID type):

        mix ecto.migrate -r Authable.Repo

  6. You are ready to go!

## Usage

### Generic Token Storage

To handle all possible token types, a generic token storage scheme is used for `Authable.Token`. So, it can be used for all OAuth2 tokens and any other token scheme like confirmation token, password recovery tokens, mail list tokens, session tokens and etc...

      :name, :string # Name of the token
      :value, :string # Value of the token
      :expires_at, :integer # Unix timestamp for when the token will expire
      :details, :jsonb # Storage for all other information
      :user_id # User(resource owner) foreign key

### Authorizing an App (Install App)

To authorize an app `Authable.OAuth2.authorize_app/2` function can be used.

### Generating Access Token

Authable has 4 grant types (authorization_code, password, client_credentials and refresh_token) to get an access token by default. To extend or use your own grant-type strategy, add your strategy into config and implement `authorize(params)` function and return a `Authable.Token` struct.

`Authable.OAuth2.authorize(params)` will automatically determine which strategy to use by grant type. Then it authorize client and returns an access token to make further requests to resource server.

Note: To enable a strategy add it to config and to disable a strategy remove from the config.

### Authentication Helpers

Authable has 2 main authentication patterns,
1) Basic Authentication header resolver and
2) Token Authentication, including `Bearer` token and `Session` token.

All authentication patterns return on success a `Authable.User` struct and on all other conditions it returns nil.

## Test

To run tests, jump into authable directory and run the command:

    mix test

## Contributing

### Issues, Bugs, Documentation, Enhancements

1) Fork the project
2) Make your improvements and write your tests.
3) Make a pull request.

### To add new strategy:

Authable is an extensible module, you can create your strategy and share as hex package(Which can be listed on Wiki pages).

## Todo

- Documentation
- HMAC Auth will be added as a new external strategy

## References

https://tools.ietf.org/html/rfc6749
