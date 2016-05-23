defmodule Authable.ClientTest do
  use Authable.ModelCase
  import Authable.Factory

  setup do
    client_owner = create(:user)
    {:ok, [user_id: client_owner.id]}
  end

  test "changeset with valid attributes", %{user_id: user_id} do
    changeset = @client.changeset(%@client{}, %{
      user_id: user_id,
      name: "ResourceServer",
      redirect_uri: "https://example.com/oauth2_callback",
      settings: %{description: "Web client for resource server."}}
    )
    assert changeset.valid?
    assert changeset.changes.secret
  end
end
