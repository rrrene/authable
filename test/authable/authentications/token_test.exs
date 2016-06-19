defmodule Authable.Authentications.TokenTest do
  use ExUnit.Case
  use Authable.Rollbackable
  use Authable.RepoCase
  import Authable.Factory
  alias Authable.Authentications.Token, as: TokenAuthentication

  @access_token_value "access_token_1234"
  @session_token_value "session_token_1234"

  setup do
    create(:access_token, %{value: @access_token_value})
    create(:session_token, %{value: @session_token_value})
    :ok
  end

  test "authorize with bearer token" do
    authorized_user = TokenAuthentication.authenticate("access_token",
      @access_token_value)
    refute is_nil(authorized_user)
  end

  test "authorize with session token" do
    authorized_user = TokenAuthentication.authenticate("session_token",
      @session_token_value)
    refute is_nil(authorized_user)
  end
end
