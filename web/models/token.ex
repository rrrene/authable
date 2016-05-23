defmodule Authable.Token do
  @moduledoc """
  Oauth2 token store
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Timex.Time, as: Time
  alias Authable.CryptUtils, as: CryptUtils

  @resource_owner Application.get_env(:authable, :resource_owner)
  @expires_in Application.get_env(:authable, :expires_in)

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "tokens" do
    field :name, :string
    field :value, :string
    field :expires_at, :integer
    field :details, :map
    belongs_to :user, @resource_owner

    timestamps
  end

  @required_fields ~w(user_id)
  @optional_fields ~w(name details)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> put_token_value
  end

  def authorization_code_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> put_token_name("authorization_code")
    |> put_expires_at(Time.now(:seconds) + @expires_in[:authorization_code])
  end

  def refresh_token_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> put_token_name("refresh_token")
    |> put_expires_at(Time.now(:seconds) + @expires_in[:refresh_token])
  end

  def access_token_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> put_token_name("access_token")
    |> put_expires_at(Time.now(:seconds) + @expires_in[:access_token])
  end

  def session_token_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> put_token_name("session_token")
    |> put_expires_at(Time.now(:seconds) + @expires_in[:session_token])
  end

  def is_expired?(token) do
    token.expires_at < Time.now(:seconds)
  end

  defp put_token_value(model_changeset) do
    put_change(model_changeset, :value, CryptUtils.generate_token)
  end

  defp put_token_name(model_changeset, name) do
    put_change(model_changeset, :name, name)
  end

  defp put_expires_at(model_changeset, expires_at) do
    put_change(model_changeset, :expires_at, expires_at)
  end
end
