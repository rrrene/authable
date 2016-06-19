defmodule Authable.GrantTypes.Password do
  @moduledoc """
  Password grant type for OAuth2 Authorization Server
  """

  import Authable.GrantTypes.Base
  alias Authable.Utils.Crypt, as: CryptUtil

  @repo Application.get_env(:authable, :repo)
  @resource_owner Application.get_env(:authable, :resource_owner)
  @client Application.get_env(:authable, :client)

  def authorize(params) do
    authorize(params["email"], params["password"], params["client_id"],
      params["scope"])
  end

  defp authorize(email, password, client_id, scope) do
    client = @repo.get(@client, client_id)
    user = @repo.get_by(@resource_owner, email: email)
    if client && user && match_with_user_password(password, user) do
      create_oauth2_tokens(user, grant_type, client_id, scope)
    end
  end

  defp grant_type, do: "password"

  defp match_with_user_password(password, user) do
    CryptUtil.match_password(password, Map.get(user, :password, ""))
  end
end
