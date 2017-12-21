defmodule GameOfLife.PrinterTest do
  use ExUnit.Case, async: true

  alias GameOfLife.Board
  alias GameOfLife.Printer

  test "sort_cells/1 sorts board cells to print" do
    cells =
      (for x <- 0..3, y <- 0..2, do: {x, y})
      |> Enum.shuffle()
    board = %Board{cells: cells, width: 4, height: 3}

    %{cells: cells} = Printer.sort_cells(board)

    assert cells == [
      {0, 0}, {1, 0}, {2, 0}, {3, 0},
      {0, 1}, {1, 1}, {2, 1}, {3, 1},
      {0, 2}, {1, 2}, {2, 2}, {3, 2},
    ]
  end
end
