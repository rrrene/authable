defmodule Authable.User do
  @moduledoc """
  Oauth2 resource owner
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Authable.CryptUtils

  @token_store Application.get_env(:authable, :token_store)
  @client Application.get_env(:authable, :client)
  @app Application.get_env(:authable, :app)

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :email, :string
    field :password, :string
    field :settings, :map
    has_many :clients, @client
    has_many :tokens, @token_store
    has_many :apps, @app

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w(settings)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(email), @optional_fields)
    |> validate_length(:email, min: 6, max: 255)
    |> validate_format(:email,
         ~r/\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end

  def settings_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(settings), [])
  end

  def registration_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> unique_constraint(:email)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 8, max: 32)
    |> put_password_hash
  end

  defp put_password_hash(model_changeset) do
    case model_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(model_changeset, :password, CryptUtils.salt_password(pass))
      _ ->
        model_changeset
    end
  end

end
