defmodule Authable.RefreshTokenGrantType do
  @moduledoc """
  RefreshToken grant type for OAuth2 Authorization Server
  """

  import Authable.BaseGrantType

  @repo Application.get_env(:authable, :repo)
  @resource_owner Application.get_env(:authable, :resource_owner)
  @token_store Application.get_env(:authable, :token_store)
  @client Application.get_env(:authable, :client)
  @app Application.get_env(:authable, :app)

  def authorize(params) do
    authorize(params["client_id"], params["client_secret"],
      params["refresh_token"])
  end

  defp authorize(client_id, client_secret, refresh_token) do
    token = @repo.get_by(@token_store, value: refresh_token)
    if token && !@token_store.is_expired?(token) &&
       token.details["client_id"] == client_id do
      client = @repo.get_by(@client, id: client_id, secret: client_secret)
      user = @repo.get(@resource_owner, token.user_id)
      if client && user && app_authorized?(user.id, client.id) do
        access_token = create_oauth2_tokens(user, grant_type, client_id,
          token.details["scope"])
        @repo.delete!(token)
        access_token
      end
    end
  end

  defp grant_type, do: "refresh_token"


end
