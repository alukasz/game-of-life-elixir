defmodule GameOfLife.CellTest do
  use ExUnit.Case

  alias GameOfLife.Cell

  test "get/1 returns cell by coordinates" do
    coords = {1, 2}

    {:ok, pid} = Cell.start_link([], coords)

    assert Cell.get(coords) == {:ok, pid}
  end

  test "get/2 returns error tuple when cell doesn't exist" do
    assert Cell.get({1, 2}) == {:error, :not_exists}
  end
end
