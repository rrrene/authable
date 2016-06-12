defmodule Authable.TokenAuthentication do
  @moduledoc """
  Bearer Authentication authenticate
  """

  @repo Application.get_env(:authable, :repo)
  @resource_owner Application.get_env(:authable, :resource_owner)
  @token_store Application.get_env(:authable, :token_store)

  def authenticate(token_name, token_value) do
    token = @repo.get_by(@token_store, value: token_value, name: token_name)
    if token && !@token_store.is_expired?(token) do
      @repo.get(@resource_owner, token.user_id)
    end
  end
end
