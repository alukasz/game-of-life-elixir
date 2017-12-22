defmodule GameOfLife.Neighbours do
  @supervisor GameOfLife.NeighboursCounterSupervisor

  alias GameOfLife.Cell

  def count(pid, neighbours, time) do
    Task.Supervisor.start_child(@supervisor, fn ->
      live = Enum.reduce neighbours, 0, fn neighbour, live ->
        case Cell.state(neighbour, time) do
          :live -> live + 1
          :dead -> live
        end
      end

      send(pid, {:neighbours, live, time})
    end)
  end
end
