defmodule GameOfLife.NeighboursTest do
  use ExUnit.Case

  alias GameOfLife.Board
  alias GameOfLife.CellManager
  alias GameOfLife.CellSupervisor
  alias GameOfLife.Neighbours

  setup do
    {:ok, _} = start_supervised(CellManager)
    {:ok, _} = start_supervised(CellSupervisor)
    {:ok, _} = start_supervised({Task.Supervisor,
                                 name: GameOfLife.NeighboursCounterSupervisor,
                                 restart: :transient})

    %{cells: cells} =
      %Board{width: 3, height: 3, live: [{0, 1}, {1, 2}, {1, 0}]}
      |> CellManager.start_cells()

    neighbours = List.delete(cells, {1, 1})

    {:ok, neighbours: neighbours}
  end

  test "count/3 counts neighbours and sends result", %{neighbours: neighbours} do
    Neighbours.count(self(), neighbours, 0)

    assert_receive {:neighbours, 3, 0}
  end
end
