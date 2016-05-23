defmodule Authable.AppTest do
  use Authable.ModelCase
  import Authable.Factory

  setup do
    resource_owner = create(:user)
    client_owner = create(:user)
    client = create(:client, user_id: client_owner.id)
    {:ok, [user_id: resource_owner.id, client_id: client.id]}
  end

  test "changeset with valid attributes", %{user_id: user_id, client_id: client_id} do
    changeset = @app.changeset(%@app{}, %{
        scope: "read,write",
        client_id: client_id,
        user_id: user_id
      }
    )
    assert changeset.valid?
  end
end
