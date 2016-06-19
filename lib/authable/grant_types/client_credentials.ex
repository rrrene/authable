defmodule Authable.GrantTypes.ClientCredentials do
  @moduledoc """
  ClientCredentials grant type for OAuth2 Authorization Server
  """

  import Authable.GrantTypes.Base

  @repo Application.get_env(:authable, :repo)
  @resource_owner Application.get_env(:authable, :resource_owner)
  @client Application.get_env(:authable, :client)

  def authorize(params) do
    authorize(params["client_id"], params["client_secret"])
  end

  defp authorize(client_id, client_secret) do
    client = @repo.get_by(@client, id: client_id, secret: client_secret)
    user = @repo.get(@resource_owner, client.user_id)
    if client && user do
      scopes = Enum.join(Application.get_env(:authable, :scopes), ",")
      create_oauth2_tokens(user, grant_type, client_id, scopes)
    end
  end

  defp grant_type, do: "client_credentials"
end
