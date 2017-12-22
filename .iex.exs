import GameOfLife

alias GameOfLife.Cell
alias GameOfLife.CellManager
alias GameOfLife.Printer

glider = %GameOfLife.Board{width: 20, height: 20, live: [{0, 1}, {1, 2}, {2, 2}, {2, 1}, {2, 0}]}
glider_big = %GameOfLife.Board{width: 100, height: 100, live: [{0, 1}, {1, 2}, {2, 2}, {2, 1}, {2, 0}]}

gosper_cells = [
  {24, 8},
  {22, 7}, {24, 7},
  {12, 6}, {13, 6}, {20, 6}, {21, 6}, {34, 6}, {35, 6},
  {11, 5}, {15, 5}, {20, 5}, {21, 5}, {34, 5}, {35, 5},
  {0, 4}, {1, 4}, {10, 4}, {16, 4}, {20, 4}, {21, 4},
  {0, 3}, {1, 3}, {10, 3}, {14, 3}, {16, 3}, {17, 3}, {22, 3}, {24, 3},
  {10, 2}, {16, 2}, {24, 2},
  {11, 1}, {15, 1},
  {12, 0}, {13, 0},
] |> Enum.map(fn {x, y} -> {x, y + 10} end)

gosper = %GameOfLife.Board{width: 50, height: 20, live: gosper_cells}
