defmodule GameOfLife.Rules do
  def next_state(:dead, 3), do: :live
  def next_state(:live, 2), do: :live
  def next_state(:live, 3), do: :live
  def next_state(_, _), do: :dead
end
