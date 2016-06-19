defmodule Authable.GrantTypes.AuthorizationCodeTest do
  use ExUnit.Case
  use Authable.Rollbackable
  use Authable.RepoCase
  import Authable.Factory
  alias Authable.GrantTypes.AuthorizationCode, as: AuthorizationCodeGrantType

  @scopes "read"

  setup do
    resource_owner = create(:user)
    client_owner = create(:user)
    client = create(:client, user_id: client_owner.id)
    create(:app, scope: @scopes, user_id: resource_owner.id, client_id: client.id)
    token = create(:authorization_code, user_id: resource_owner.id, details: %{client_id: client.id, redirect_uri: client.redirect_uri, scope: @scopes})
    params = %{"client_id" => client.id, "client_secret" => client.secret, "code" => token.value, "redirect_uri" => client.redirect_uri}
    {:ok, [params: params, user_id: resource_owner.id]}
  end

  test "oauth2 authorization with authorization_code grant type", %{params: params} do
    access_token = AuthorizationCodeGrantType.authorize(params)
    refute is_nil(access_token)
    assert access_token.details[:grant_type] == "authorization_code"
  end

  test "oauth2 authorization with authorization_code auto creates app", %{params: params} do
    AuthorizationCodeGrantType.authorize(params)
    assert Enum.count(@repo.all(@app)) > 0
  end

  test "can not create access_token more than one with a token with same authorization_code params", %{params: params} do
    AuthorizationCodeGrantType.authorize(params)
    second_token = AuthorizationCodeGrantType.authorize(params)
    assert is_nil(second_token)
  end
end
