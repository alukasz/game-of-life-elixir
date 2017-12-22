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

  test "start_cells/1 cells are sorted" do
    board = %Board{width: 4, height: 3}

    assert %{cells: cells} = CellManager.start_cells(board)

    assert cells == [
      {0, 0}, {1, 0}, {2, 0}, {3, 0},
      {0, 1}, {1, 1}, {2, 1}, {3, 1},
      {0, 2}, {1, 2}, {2, 2}, {3, 2},
    ]
  end


  test "start_cells/1 created cells are dead when not specified as live" do
    board = %Board{width: 1, height: 1}

    assert CellManager.start_cells(board)

    assert :dead = Cell.state({0, 0})
  end

  test "start_cells/1 sets live cells" do
    board = %Board{width: 1, height: 1, live: [{0, 0}]}

    assert CellManager.start_cells(board)

    assert :live = Cell.state({0, 0})
  end
end
