defmodule Authable.Authentications.BasicTest do
  use ExUnit.Case
  use Authable.Rollbackable
  use Authable.RepoCase
  import Authable.Factory
  alias Authable.Authentications.Basic, as: BasicAuthentication

  setup do
    user = create(:user)
    basic_auth_token = Base.encode64("#{user.email}:12345678")
    {:ok, [basic_auth_token: basic_auth_token]}
  end

  test "authorize with basic authentication hash", %{basic_auth_token: basic_auth_token} do
    authorized_user = BasicAuthentication.authenticate(basic_auth_token)
    refute is_nil(authorized_user)
  end
end
