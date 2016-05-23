defmodule Authable.PasswordGrantTypeTest do
  use ExUnit.Case
  use Authable.Rollbackable
  use Authable.RepoCase
  import Authable.Factory

  setup do
    resource_owner = create(:user)
    client_owner = create(:user)
    client = create(:client, user_id: client_owner.id)
    params = %{"email" => resource_owner.email, "password" => "12345678", "client_id" => client.id, "scope" => "read"}
    {:ok, [params: params]}
  end

  test "oauth2 authorization with password grant type", %{params: params} do
    access_token = Authable.PasswordGrantType.authorize(params)
    refute is_nil(access_token)
    assert access_token.details[:grant_type] == "password"
  end
end
