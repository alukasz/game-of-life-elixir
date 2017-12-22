# Game of Life the Erlang way

Conway's Game of Life implemented using Elixir processes as cells. There is
no "central point" which controls game. Each cell progress on it's own and communicates with other
to determine it's next state (live or dead).

Run with iex:

```
iex -S mix
# there are 2 predefined examples in .iex.exs: glider and gosper
GameOfLife.start(glider)
# or
GameOfLife.start(%GameOfLife.Board{width: 10, height: 10, live: [
  {5, 4}, {5, 5}, {5, 6} # specify cells that are alive on start
]})
```

### How cells are kept in sync?

There are 2 mechanism to allow asynchronous progress of cells.

* Each cell doesn't hold it's current state but history of states from the
  beginning. Cell can obtain other cell state at any point.

* When cell gets a message for it's state in the future, the
  request is saved. When cell progress, it replies to previously stored requests.

### What if cell dies?

* `GameOfLife.Timer` holds estimate of current game time. When cell is
  created checks time and if needed, forwards it's evolution
  to match other cells.
