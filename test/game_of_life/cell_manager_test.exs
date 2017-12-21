defmodule GameOfLife.CellManagerTest do
  use ExUnit.Case

  alias GameOfLife.Board
  alias GameOfLife.Cell
  alias GameOfLife.CellManager
  alias GameOfLife.CellSupervisor

  setup do
    {:ok, _} = start_supervised(CellSupervisor)
    {:ok, _} = start_supervised(CellManager)

    :ok
  end

  test "start_cells/1 starts cells" do
    board = %Board{width: 6, height: 7}

    assert CellManager.start_cells(board)

    assert length(Supervisor.which_children(CellSupervisor)) ==
      board.width * board.height
  end


  test "start_cells/1 created cells are dead by default" do
    board = %Board{width: 1, height: 1}

    assert CellManager.start_cells(board)

    assert :dead = Cell.state({0, 0})
  end

  test "start_cells/1 sets alive cells" do
    board = %Board{width: 1, height: 1, alive: [{0, 0}]}

    assert CellManager.start_cells(board)

    assert :live = Cell.state({0, 0})
  end
end
