defmodule Authable.Factory do
  @moduledoc """
  Generates factories
  """

  @repo Application.get_env(:authable, :repo)
  @resource_owner Application.get_env(:authable, :resource_owner)
  @token_store Application.get_env(:authable, :token_store)
  @client Application.get_env(:authable, :client)
  @app Application.get_env(:authable, :app)

  use ExMachina.Ecto, repo: @repo

  def factory(:user) do
    %@resource_owner{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: Comeonin.Bcrypt.hashpwsalt("12345678")
    }
  end

  def factory(:client) do
    %@client{
      user: build(:user),
      name: sequence(:name, &"client#{&1}"),
      secret: SecureRandom.urlsafe_base64,
      redirect_uri: "https://example.com/oauth2-redirect-path",
      settings: %{
        name: "example",
        icon: "https://example.com/icon.png"
      }
    }
  end

  def factory(:session_token) do
    %@token_store{
      user: build(:user),
      name: "session_token",
      value: "st1234567890",
      expires_at: Timex.Time.now(:seconds) + 3600
    }
  end

  def factory(:access_token) do
    %@token_store{
      user: build(:user),
      name: "access_token",
      value: "at1234567890",
      expires_at: Timex.Time.now(:seconds) + 3600,
      details: %{
        scope: "read",
        grant_type: "authorization_code",
        client_id: build(:client).id
      }
    }
  end

  def factory(:refresh_token) do
    %@token_store{
      user_id: build(:user),
      name: "refresh_token",
      value: "rt1234567890",
      expires_at: Timex.Time.now(:seconds) + 3600,
      details: %{
        grant_type: "authorization_code",
        client_id: build(:client).id,
        scope: "read"
      }
    }
  end

  def factory(:authorization_code) do
    %@token_store{
      user_id: build(:user),
      name: "authorization_code",
      value: "a0123456789c",
      expires_at: Timex.Time.now(:seconds) + 900,
      details: %{
        scope: "read",
        grant_type: "password",
        client_id: build(:client).id
      }
    }
  end

  def factory(:app) do
    %@app{
      user_id: build(:user),
      client_id: build(:client),
      scope: "read,write"
    }
  end
end
