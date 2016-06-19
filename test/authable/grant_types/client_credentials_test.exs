defmodule Authable.GrantTypes.ClientCredentialsTest do
  use ExUnit.Case
  use Authable.Rollbackable
  use Authable.RepoCase
  import Authable.Factory
  alias Authable.GrantTypes.ClientCredentials, as: ClientCredentialsGrantType

  setup do
    client_owner = create(:user)
    client = create(:client, user_id: client_owner.id)
    params = %{"client_id" => client.id, "client_secret" => client.secret}
    {:ok, [params: params]}
  end

  test "oauth2 authorization with client_credentials grant type", %{params: params} do
    access_token = ClientCredentialsGrantType.authorize(params)
    refute is_nil(access_token)
    assert access_token.details[:grant_type] == "client_credentials"
  end
end
