defmodule Authable do
  @moduledoc """
  Authable worker for OAuth2 provider implementation.
  """

  use Application

  @repo Application.get_env(:authable, :repo)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(@repo, [])
    ]

    opts = [strategy: :one_for_one, name: Authable.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
