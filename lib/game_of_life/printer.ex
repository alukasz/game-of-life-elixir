defmodule GameOfLife.Printer do
  use GenServer

  alias GameOfLife.Board
  alias GameOfLife.Cell

  @period Application.get_env(:game_of_life, :period)

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def print(%Board{} = board) do
    GenServer.call(__MODULE__, {:print, board})
  end

  def sort_cells(%{cells: cells, width: width} = board) do
    mapper = fn {x, y} -> y * width + x end
    cells = Enum.sort_by(cells, mapper, &<=/2)

    %{board | cells: cells}
  end

  def init(_) do
    {:ok, %{board: %Board{}, time: 0}}
  end

  def handle_call({:print, %{cells: cells} = board}, _, state) do
    schedule_printing()

    {:reply, :ok, %{state | board: sort_cells(board)}}
  end

  def handle_info(:print, %{board: board, time: time} = state) do
    schedule()
    do_print(board, time)

    {:noreply, %{state | time: time + 1}}
  end

  defp do_print(%{width: width, cells: cells}, time) do
    cells
    |> Enum.map(&Cell.state(&1, time))
    |> Enum.map(fn
      :live -> "#"
      :dead -> "_"
    end)
    |> Enum.chunk_every(width)
    |> Enum.map(fn chunk -> [chunk | "\n"] end)
    |> List.insert_at(0, "\n")
    |> IO.puts()
  end

  defp schedule_printing do
    Process.send_after(self(), :print, :timer.seconds(3))
  end

  defp schedule do
    Process.send_after(self(), :print, @period)
  end
end
