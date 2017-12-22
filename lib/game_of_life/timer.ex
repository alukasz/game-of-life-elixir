defmodule GameOfLife.Timer do
  use GenServer

  @period Application.get_env(:game_of_life, :period)

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_timer do
    GenServer.call(__MODULE__, :start_timer)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  def init(_) do
    {:ok, %{time: 0}}
  end

  def handle_call(:start_timer, _, _) do
    schedule()

    {:reply, :ok, %{time: 0}}
  end
  def handle_call(:get, _, %{time: time} = state) do
    {:reply, time, state}
  end

  def handle_info(:inc_timer, %{time: time}) do
    schedule()

    {:noreply, %{time: time + 1}}
  end

  defp schedule do
    Process.send_after(self(), :inc_timer, @period)
  end
end
