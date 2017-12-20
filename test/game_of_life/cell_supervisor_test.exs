defmodule GameOfLife.CellSupervisorTest do
  use ExUnit.Case

  alias GameOfLife.CellSupervisor

  setup do
    {:ok, pid} = start_supervised(CellSupervisor)

    {:ok, sup: pid}
  end

  test "start_child/1 starts new cell", %{sup: sup} do
    coords = {1, 2}

    assert {:ok, pid} = CellSupervisor.start_cell(coords)

    assert pid in Enum.map(Supervisor.which_children(sup), &elem(&1, 1))
  end
end
