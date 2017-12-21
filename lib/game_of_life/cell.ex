defmodule GameOfLife.Cell do
  use GenServer

  alias GameOfLife.Board

  @registry GameOfLife.CellRegistry

  defmodule State do
    defstruct [:coords, :state, time: 0, neighbours: [], history: []]
  end

  def start_link(_, [%Board{} = board, {_, _} = coords]) do
    args = [coords, neighbours(coords, board)]
    GenServer.start_link(__MODULE__, args, name: via_tuple(coords))
  end

  def neighbours({x, y}, %{width: w, height: h}) do
    for xi <- Range.new(x - 1, x + 1), yi <- Range.new(y - 1, y + 1),
        xi >= 0, xi < w, yi >= 0, yi < h, xi != x or yi != y do
      {xi, yi}
    end
  end

  def get({_, _} = coords) do
    case Registry.lookup(@registry, coords) do
      [{pid, _}] -> {:ok, pid}
      _ -> {:error, :not_exists}
    end
  end

  def init([coords, neighbours]) do
    {:ok, %State{coords: coords, neighbours: neighbours}}
  end

  defp via_tuple(coords) do
    {:via, Registry, {@registry, coords}}
  end
end
