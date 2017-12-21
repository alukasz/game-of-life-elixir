defmodule GameOfLife.RulesTest do
  use ExUnit.Case, async: true

  alias GameOfLife.Rules

  describe "next_state/2" do
    test "live cell without enough live neighbours becomes dead" do
      assert Rules.next_state(:live, 0) == :dead
      assert Rules.next_state(:live, 1) == :dead
    end

    test "live cell with 2 or 3 live neighbours stays live" do
      assert Rules.next_state(:live, 2) == :live
      assert Rules.next_state(:live, 3) == :live
    end

    test "live cell with too much dead neighbours becomes dead" do
      assert Rules.next_state(:live, 4) == :dead
      assert Rules.next_state(:live, 8) == :dead
    end

    test "dead cell without enough live neighbours stays dead" do
      assert Rules.next_state(:dead, 0) == :dead
      assert Rules.next_state(:dead, 2) == :dead
    end

    test "dead cell 3 live neighbours becomes live" do
      assert Rules.next_state(:dead, 3) == :live
    end

    test "dead cell with too many dead neighbours stays dead" do
      assert Rules.next_state(:dead, 4) == :dead
      assert Rules.next_state(:dead, 6) == :dead
    end
  end
end
