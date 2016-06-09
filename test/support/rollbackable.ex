defmodule Authable.Rollbackable do
  @moduledoc """
  This module allows auto DB rollback on each test block execution.
  """

  use ExUnit.CaseTemplate

  @repo Application.get_env(:authable, :repo)

  using do
    quote do
    end
  end

  setup do
    # Wrap this case in a transaction
    Ecto.Adapters.SQL.begin_test_transaction(@repo)

    # Roll it back once we are done
    on_exit fn ->
      Ecto.Adapters.SQL.rollback_test_transaction(@repo)
    end

    :ok
  end
end
