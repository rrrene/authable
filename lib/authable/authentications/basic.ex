defmodule Authable.Authentications.Basic do
  @moduledoc """
  Basic Authentication authenticate
  """

  alias Authable.Utils.Crypt, as: CryptUtil

  @repo Application.get_env(:authable, :repo)
  @resource_owner Application.get_env(:authable, :resource_owner)

  def authenticate(auth_credentials) do
    {:ok, credentials} = Base.decode64(auth_credentials)
    [email, password] = String.split(credentials, ":")
    authenticate(email, password)
  end

  defp authenticate(email, password) do
    user = @repo.get_by(@resource_owner, email: email)
    if user && match_with_user_password(password, user), do: user, else: nil
  end

  defp match_with_user_password(password, user) do
    CryptUtil.match_password(password, Map.get(user, :password, ""))
  end
end
