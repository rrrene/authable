defmodule Authable.AuthorizationCodeGrantType do
  @moduledoc """
  AuthorizationCode grant type for OAuth2 Authorization Server
  """

  import Authable.BaseGrantType

  @repo Application.get_env(:authable, :repo)
  @resource_owner Application.get_env(:authable, :resource_owner)
  @token_store Application.get_env(:authable, :token_store)
  @client Application.get_env(:authable, :client)
  @app Application.get_env(:authable, :app)

  def authorize(params) do
    client = @repo.get_by!(@client, id: params["client_id"], secret:
      params["client_secret"])
    if client, do: authorize(params["code"], params["redirect_uri"], client.id),
               else: nil
  end

  defp authorize(code, redirect_uri, client_id) do
    access_token = nil
    token = @repo.get_by(@token_store, value: code)
    if token && !@token_store.is_expired?(token) &&
       token.details["redirect_uri"] == redirect_uri &&
       token.details["client_id"] == client_id do
      user = @repo.get!(@resource_owner, token.user_id)
      app_authorized?(user.id, client_id)
      access_token = create_oauth2_tokens(user, grant_type, client_id,
                       token.details["scope"])
      @repo.delete!(token)
    end
    access_token
  end

  defp grant_type, do: "authorization_code"
end
