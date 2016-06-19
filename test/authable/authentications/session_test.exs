defmodule Authable.Authentications.SessionTest do
  use ExUnit.Case
  use Authable.Rollbackable
  use Authable.RepoCase
  import Authable.Factory
  alias Authable.Authentications.Session, as: SessionAuthentication

  @session_token_value "session_token_1234"

  setup do
    create(:session_token, %{value: @session_token_value})
    :ok
  end

  test "authorize with bearer authentication hash" do
    authorized_user = SessionAuthentication.authenticate(@session_token_value)
    refute is_nil(authorized_user)
  end
end
