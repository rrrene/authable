defmodule Authable.SessionAuthentication do
  @moduledoc """
  Session Authentication authenticate
  """

  alias Authable.TokenAuthentication

  def authenticate(session_token) do
    TokenAuthentication.authenticate("session_token", session_token)
  end
end
