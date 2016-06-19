defmodule Authable.Models.UserTest do
  use Authable.ModelCase

  @valid_attrs %{email: "foo@example.com", password: "s3cr3tX.", settings: %{}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = @resource_owner.changeset(%@resource_owner{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = @resource_owner.changeset(%@resource_owner{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset, email too short" do
    changeset = @resource_owner.changeset(
      %@resource_owner{}, Map.put(@valid_attrs, :email, "")
    )
    refute changeset.valid?
  end

  test "changeset, email invalid format" do
    changeset = @resource_owner.changeset(
      %@resource_owner{}, Map.put(@valid_attrs, :email, "foo.com")
    )
    refute changeset.valid?
  end

  test "registration_changeset, encrypt password" do
    changeset = @resource_owner.registration_changeset(%@resource_owner{}, @valid_attrs)
    assert changeset.changes.password
  end

  test "registration_changeset, password too short" do
    changeset = @resource_owner.registration_changeset(
      %@resource_owner{}, Map.put(@valid_attrs, :password, "1234567")
    )
    refute changeset.valid?
  end

  test "settings_changeset with valid attributes" do
    changeset = @resource_owner.settings_changeset(
      %@resource_owner{}, %{settings: %{language: "tr"}}
    )
    assert changeset.valid?
  end
end
