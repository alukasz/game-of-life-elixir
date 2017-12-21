defmodule GameOfLife.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: GameOfLife.CellRegistry},
      GameOfLife.CellSupervisor,
      GameOfLife.CellManager,
      GameOfLife.Printer
    ]
    opts = [
      strategy: :one_for_one,
      name: GameOfLife.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
