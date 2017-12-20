defmodule GameOfLife.Cell do
  use GenServer

  def start_link({_, _} = coords) do
    GenServer.start_link(__MODULE__, coords)
  end

  def init(coords) do
    {:ok, %{coords: coords}}
  end
end
