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

  def handle_call({:start_cells,  board}, _, state) do
    board = do_start_cells(board)

    {:reply, board, state}
  end

  defp do_start_cells(%{width: width, height: height} = board) do
    cells = for y <- 1..height, x <- 1..width do
      coords = {x - 1, y - 1}
      state = initial_state(coords, board)
      {:ok, _} = CellSupervisor.start_cell(board, coords, state)

      coords
    end

    %{board | cells: cells}
  end

  def initial_state(coords, %{live: live}) do
    case coords in live do
      true -> :live
      _ -> :dead
    end
  end
end
