defmodule GameOfLife.CellSupervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_cell(board, coords) do
    Supervisor.start_child(__MODULE__, [[board, coords]])
  end

  def init(_) do
    children = [
      GameOfLife.Cell
    ]

    Supervisor.init(children, strategy: :simple_one_for_one)
  end
end
