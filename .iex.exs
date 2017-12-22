import GameOfLife

alias GameOfLife.Cell
alias GameOfLife.CellManager
alias GameOfLife.Printer

glider = %GameOfLife.Board{width: 20, height: 20, live: [{0, 1}, {1, 2}, {2, 2}, {2, 1}, {2, 0}]}
