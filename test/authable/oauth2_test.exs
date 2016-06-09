defmodule Authable.OAuth2Test do
  use ExUnit.Case
  use Authable.Rollbackable
  use Authable.RepoCase
  import Authable.Factory
  import Ecto.Query, only: [where: 2]
  alias Authable.OAuth2, as: OAuth2
  alias Authable.SuspiciousActivityError, as: SuspiciousActivityError

  @redirect_uri "https://xyz.com/rd"
  @scopes "read"

  test "raise when strategy not enabled" do
    params = %{"grant_type" => "urn"}
    assert_raise SuspiciousActivityError, fn -> OAuth2.authorize(params) end
  end

  test "resource_owner authorize app for a client" do
    resource_owner = create(:user)
    client_owner = create(:user)
    client = create(:client, user_id: client_owner.id,
                    redirect_uri: @redirect_uri)
    params = %{"client_id" => client.id, "redirect_uri" => @redirect_uri,
               "scope" => @scopes}
    app = OAuth2.authorize_app(resource_owner, params)
    refute is_nil(app)
  end

  test "resource_owner authorize app update scopes for a client" do
    new_scopes = "read,write"
    resource_owner = create(:user)
    client_owner = create(:user)
    client = create(:client, user_id: client_owner.id,
                    redirect_uri: @redirect_uri)
    app = create(:app, user_id: resource_owner.id, client_id: client.id,
                 scope: @scopes)

    params = %{"client_id" => client.id, "redirect_uri" => @redirect_uri,
               "scope" => new_scopes}
    same_app = OAuth2.authorize_app(resource_owner, params)
    assert app.id == same_app.id
    assert same_app.scope == new_scopes
  end

  test "does not allow to change redirect_uri when authorize app" do
    resource_owner = create(:user)
    client_owner = create(:user)
    client = create(:client, user_id: client_owner.id,
                    redirect_uri: @redirect_uri)
    params = %{"client_id" => client.id, "redirect_uri" => "https://xyz.com/nx",
               "scope" => @scopes}
    assert_raise Ecto.NoResultsError,
                 fn -> OAuth2.authorize_app(resource_owner, params) end
  end

  test "deletes app and user's all client tokens" do
    resource_owner = create(:user)
    client_owner = create(:user)
    client = create(:client, user_id: client_owner.id,
                    redirect_uri: @redirect_uri)
    app = create(:app, user_id: resource_owner.id, client_id: client.id,
                 scope: @scopes)
    create(:access_token, user_id: resource_owner.id, details: %{
      client_id: client.id
    })
    create(:refresh_token, user_id: resource_owner.id, details: %{
      client_id: client.id
    })
    OAuth2.revoke_app_authorization(resource_owner, %{"id" => app.id})
    tokens = @token_store
    |> where(user_id: ^resource_owner.id)
    |> @repo.all
    assert Enum.count(tokens) == 0
    assert is_nil(@repo.get(@app, app.id))
  end
end
