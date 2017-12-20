defmodule GameOfLife.Cell do
  use GenServer

  @registry GameOfLife.CellsRegistry

  def start_link(_, {_, _} = coords) do
    GenServer.start_link(__MODULE__, coords, name: via_tuple(coords))
  end

  def get({_, _} = coords) do
    case Registry.lookup(@registry, coords) do
      [{pid, _}] -> {:ok, pid}
      _ -> {:error, :not_exists}
    end
  end

  def init(coords) do
    {:ok, %{coords: coords}}
  end

  defp via_tuple(coords) do
    {:via, Registry, {@registry, coords}}
  end
end
