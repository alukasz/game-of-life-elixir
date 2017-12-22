defmodule GameOfLife.Cell do
  use GenServer

  alias GameOfLife.Board
  alias GameOfLife.Rules
  alias GameOfLife.Neighbours
  alias GameOfLife.Timer

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

  def state(coords, time \\ 0) do
    GenServer.call(via_tuple(coords), {:state, time})
  end

  def init([coords, state, neighbours]) do
    case Timer.get() do
      0 ->
        schedule()

      time ->
        IO.inspect "forwarding #{time} generations"
        fast_forward(0, time)
    end

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
    next_state = Rules.next_state(state_at(history, time), live)
    history = [{time + 1, next_state} | history]
    requests = check_requests(cell.requests, history)

    {:noreply, %{cell | history: history, requests: requests}}
  end
  def handle_info({:fast_forward, time, time}, cell) do
    schedule()

    {:noreply, cell}
  end
  def handle_info({:fast_forward, time, until}, cell) do
    fast_forward(time + 1, until)
    Neighbours.count(self(), cell.neighbours, time)

    {:noreply, %{cell | time: time + 1}}
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
  defp fast_forward(from, until) do
    send(self(), {:fast_forward, from, until})
  end
end
