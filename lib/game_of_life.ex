defmodule GameOfLife do
  alias GameOfLife.Board
  alias GameOfLife.CellManager
  alias GameOfLife.Printer

  def start(%Board{} = board) do
    board
    |> CellManager.start_cells()
    |> Printer.print()
  end
end
