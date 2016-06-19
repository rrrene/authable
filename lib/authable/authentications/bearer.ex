defmodule Authable.Authentications.Bearer do
  @moduledoc """
  Bearer Authentication authenticate
  """

  alias Authable.Authentications.Token, as: TokenAuthentication

  def authenticate(%{"access_token" => access_token}) do
    authenticate(access_token)
  end

  def authenticate(access_token) do
    TokenAuthentication.authenticate("access_token", access_token)
  end
end
