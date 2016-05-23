{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start

Mix.Task.run "ecto.drop", ~w(-r Authable.Repo)
Mix.Task.run "ecto.create", ~w(-r Authable.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Authable.Repo --quiet)
