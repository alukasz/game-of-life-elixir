defmodule GameOfLife.CellManagerTest do
  use ExUnit.Case

  alias GameOfLife.Board
  alias GameOfLife.CellManager
  alias GameOfLife.CellSupervisor

  setup do
    {:ok, _} = start_supervised(CellSupervisor)
    {:ok, _} = start_supervised(CellManager)

    :ok
  end

  test "start_cells/1 starts cells" do
    board = %Board{width: 6, height: 7}

    assert :ok = CellManager.start_cells(board)

    assert length(Supervisor.which_children(CellSupervisor)) ==
      board.width * board.height
  end
end
