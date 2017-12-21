defmodule GameOfLife.CellManager do
  use GenServer

  alias GameOfLife.Board
  alias GameOfLife.CellSupervisor

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_cells(%Board{} = board) do
    GenServer.call(__MODULE__, {:start_cells, board})
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:start_cells, %{width: w, height: h} = board}, _, state) do
    for x <- 1..w, y <- 1..h do
      CellSupervisor.start_cell(board, {x - 1, y - 1})
    end

    {:reply, :ok, state}
  end
end
