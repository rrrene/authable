defmodule Authable.RefreshTokenGrantTypeTest do
  use ExUnit.Case
  use Authable.Rollbackable
  use Authable.RepoCase
  import Authable.Factory

  setup do
    resource_owner = create(:user)
    client_owner = create(:user)
    client = create(:client, user_id: client_owner.id)
    app = create(:app, user_id: resource_owner.id, client_id: client.id)
    token = create(:refresh_token, user_id: resource_owner.id, details: %{client_id: client.id, scope: "read"})
    params = %{"client_id" => client.id, "client_secret" => client.secret, "refresh_token" => token.value}
    {:ok, [params: params, app: app]}
  end

  test "oauth2 authorization with refresh_token grant type", %{params: params} do
    access_token = Authable.RefreshTokenGrantType.authorize(params)
    refute is_nil(access_token)
    assert access_token.details[:grant_type] == "refresh_token"
  end

  test "can not create access_token more than one with a token with same refresh_token params", %{params: params} do
    Authable.RefreshTokenGrantType.authorize(params)
    access_token = Authable.RefreshTokenGrantType.authorize(params)
    assert is_nil(access_token)
  end

  test "fails if app is deleted by resource_owner", %{params: params, app: app} do
    @repo.delete!(app)

    assert is_nil(Authable.RefreshTokenGrantType.authorize(params))
  end
end
