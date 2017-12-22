defmodule GameOfLife.Cell do
  use GenServer

  alias GameOfLife.Board
  alias GameOfLife.Rules
  alias GameOfLife.Neighbours

  @registry GameOfLife.CellRegistry
  @period Application.get_env(:game_of_life, :period)

  defmodule State do
    defstruct [:coords, time: 0, neighbours: [], history: [], requests: []]
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
    schedule()
    {:ok, %State{coords: coords, neighbours: neighbours,
                 history: [{0, state}]}}
  end

  def handle_call({:state, time}, _, %{time: time, state: state} = cell) do
    {:reply, state, cell}
  end
  def handle_call({:state, time}, from, %{history: history} = cell) do
    case state_at(history, time) do
      :future ->
        {:noreply, %{cell | requests: [{from, time} | cell.requests]}}

      state ->
        {:reply, state, cell}
    end
  end

  def handle_info(:next, %{time: time} = cell) do
    schedule()
    Neighbours.count(self(), cell.neighbours, time)

    {:noreply, %{cell | time: time + 1}}
  end
  def handle_info({:neighbours, live, time}, %{history: history} = cell) do
    state = Rules.next_state(state_at(history, time), live)
    history = [{time + 1, state} | history]
    requests = check_requests(cell.requests, history)

    {:noreply, %{cell | history: history, requests: requests}}
  end

  defp check_requests([], _), do: []
  defp check_requests(requests, history) do
    {_, to_send} = Enum.split_with requests, fn {from, time} ->
      case state_at(history, time) do
        :future ->
          false

        state ->
          GenServer.reply(from, state)
          true
      end
    end

    to_send
  end

  defp via_tuple(coords) do
    {:via, Registry, {@registry, coords}}
  end

  defp state_at([], _), do: :future
  defp state_at([{time, state} | _], time), do: state
  defp state_at([_ | history], time), do: state_at(history, time)

  defp schedule do
    Process.send_after(self(), :next, @period)
  end
end
