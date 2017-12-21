defmodule GameOfLife.CellTest do
  use ExUnit.Case

  alias GameOfLife.Board
  alias GameOfLife.Cell

  test "new cell is dead" do
    coords = {0, 0}

    {:ok, _} = Cell.start_link([], [%Board{}, coords])

    assert Cell.state(coords) == :dead
  end

  test "get/1 returns cell by coordinates" do
    coords = {1, 2}

    {:ok, pid} = Cell.start_link([], [%Board{}, coords])

    assert Cell.get(coords) == {:ok, pid}
  end

  test "get/2 returns error tuple when cell doesn't exist" do
    assert Cell.get({1, 2}) == {:error, :not_exists}
  end

  describe "set_state/2" do
    setup do
      coords = {0, 0}
      mfa = {Cell, :start_link, [[], [%Board{}, coords]]}
      {:ok, _} = start_supervised(Cell, start: mfa)

      {:ok, coords: coords}
    end

    test "sets cell state", %{coords: coords} do
      for state <- [:live, :dead] do
        assert Cell.set_state(coords, state) == {:ok, state}

        assert Cell.state(coords) == state
      end
    end
  end

  describe "neighbours/2 returns neighbours of cell" do
    setup do
      board = %Board{width: 4, height: 4}

      {:ok, board: board}
    end

    test "when cell is in the corner", %{board: board} do
      coords = {0, 0}

      neighbours = Cell.neighbours(coords, board)

      assert length(neighbours) == 3

      assert {0, 1} in neighbours
      assert {1, 0} in neighbours
      assert {1, 1} in neighbours
    end

    test "when cell is near the edge", %{board: board} do
      coords = {3, 1}

      neighbours = Cell.neighbours(coords, board)

      assert length(neighbours) == 5
      assert {3, 0} in neighbours
      assert {3, 2} in neighbours
      assert {2, 0} in neighbours
      assert {2, 1} in neighbours
      assert {2, 2} in neighbours
    end

    test "when cell is in the center", %{board: board} do
      coords = {1, 1}

      neighbours = Cell.neighbours(coords, board)

      assert length(neighbours) == 8
      assert {0, 0} in neighbours
      assert {0, 1} in neighbours
      assert {0, 2} in neighbours
      assert {1, 0} in neighbours
      assert {1, 2} in neighbours
      assert {2, 0} in neighbours
      assert {2, 1} in neighbours
      assert {2, 2} in neighbours
    end
  end
end
