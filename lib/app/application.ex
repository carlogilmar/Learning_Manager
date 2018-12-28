defmodule Etoile.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(ExGram, []),
      supervisor(Etoile.Bot, [:polling, ExGram.Config.get(:ex_gram, :token) ])
    ]

    opts = [strategy: :one_for_one, name: Etoile.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
