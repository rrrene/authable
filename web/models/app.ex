defmodule Authable.App do
  @moduledoc """
  Installed apps
  """

  use Ecto.Schema
  import Ecto.Changeset

  @resource_owner Application.get_env(:authable, :resource_owner)
  @client Application.get_env(:authable, :client)
  @app Application.get_env(:authable, :app)

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "apps" do
    field :scope, :string
    belongs_to :client, @client
    belongs_to :user, @resource_owner

    timestamps
  end

  @required_fields ~w(scope client_id user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
