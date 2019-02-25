defmodule Simulation.World.WorldAPI do
  @moduledoc """
  This module will be the world API and other objects will deal with this API.
  """
  require Logger
  use GenServer
  @board_size 5
  alias Simulation.World.Position

  def start_link() do
    Logger.debug("WorldAPI starting")
    GenServer.start_link(__MODULE__, %{used_positions: []} ,name: __MODULE__)
  end

  def init(state) do
    Logger.debug("The state is ...")
    IO.inspect(state)
    {:ok, state}
  end
  def get_patch(size) do
    GenServer.call(__MODULE__, :get_empty_positions)
    |> Enum.take(size)
    |> update_used_positions()
  end

  defp update_used_positions(new_positions) do
    GenServer.cast(__MODULE__, {:update_used_positions, new_positions})
    new_positions
  end

  def handle_cast({:update_used_positions, new_positions}, state) do
    {_old, new_state} =
      state
      |> Map.get_and_update!(:used_positions, fn current_value ->
        {current_value, Enum.concat(current_value, new_positions)}
      end)

    {:noreply, new_state}
  end

  def handle_call(:get_empty_positions, _from, state) do
    {:reply, state |> get_empty_positions(), state}
  end

  defp get_empty_positions(state) do
    get_all_positions()
    |> filter_used_positions(state)
  end

  defp filter_used_positions(all_positions, state) do
    Enum.filter(all_positions, fn x -> not Enum.member?(Map.get(state, :used_positions), x) end)
  end

  defp get_all_positions() do
    Enum.reduce(0..@board_size, [], fn(x, acc) ->
      acc ++
      Enum.map(0..@board_size, fn(y) ->
        %Position{lat: x, long: y}
      end)
    end)
  end
end
