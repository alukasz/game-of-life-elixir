defmodule GameOfLife.CellManager do
  use GenServer

  alias GameOfLife.Board
  alias GameOfLife.Cell
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
    board =
      board
      |> do_start_cells()
      |> initialize_cells()

    {:reply, board, state}
  end

  defp do_start_cells(%{width: width, height: height} = board) do
    cells = for x <- 1..width, y <- 1..height do
      coords = {x - 1, y - 1}
      {:ok, _} = CellSupervisor.start_cell(board, coords)

      coords
    end

    %{board | cells: cells}
  end

  defp initialize_cells(%{alive: alive} = board) do
    Enum.each(alive, &turn_cell_alive/1)

    board
  end

  defp turn_cell_alive(coords) do
    Cell.set_state(coords, :live)
  end
end
