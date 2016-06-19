defmodule Authable.Authentications.Session do
  @moduledoc """
  Session Authentication authenticate
  """

  alias Authable.Authentications.Token, as: TokenAuthentication

  def authenticate(session_token) do
    TokenAuthentication.authenticate("session_token", session_token)
  end
end
