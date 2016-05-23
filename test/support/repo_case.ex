defmodule Authable.RepoCase do
  @moduledoc """
  This module allows accessing defined repo models on init.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      @repo Application.get_env(:authable, :repo)
      @resource_owner Application.get_env(:authable, :resource_owner)
      @token_store Application.get_env(:authable, :token_store)
      @client Application.get_env(:authable, :client)
      @app Application.get_env(:authable, :app)
    end
  end
end
