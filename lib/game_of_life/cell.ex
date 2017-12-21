defmodule GameOfLife.Cell do
  use GenServer

  alias GameOfLife.Board

  @registry GameOfLife.CellRegistry

  defmodule State do
    defstruct [:coords, state: :dead, time: 0, neighbours: [], history: []]
  end

  def start_link(_, [%Board{} = board, {_, _} = coords, state]) do
    args = [coords, state, neighbours(coords, board)]
    GenServer.start_link(__MODULE__, args, name: via_tuple(coords))
  end

  def neighbours({x, y}, %{width: w, height: h}) do
    for xi <- Range.new(x - 1, x + 1), yi <- Range.new(y - 1, y + 1),
        xi >= 0, xi < w, yi >= 0, yi < h, xi != x or yi != y do
      {xi, yi}
    end
  end

  def get(coords) do
    case Registry.lookup(@registry, coords) do
      [{pid, _}] -> {:ok, pid}
      _ -> {:error, :not_exists}
    end
  end

  def state(coords, time \\ 0) do
    GenServer.call(via_tuple(coords), {:state, time})
  end

  def init([coords, state, neighbours]) do
    {:ok, %State{coords: coords, state: state,
                 neighbours: neighbours, history: [{0, state}]}}
  end

  def handle_call({:state, time}, _, %{time: time, state: state} = cell) do
    {:reply, state, cell}
  end
  def handle_call({:state, time}, _, %{history: history} = cell) do
    state = state_at(history, time)

    {:reply, state, cell}
  end

  defp via_tuple(coords) do
    {:via, Registry, {@registry, coords}}
  end

  defp state_at([{time, state} | _], time), do: state
  defp state_at([_ | history], time), do: state_at(history, time)
end
