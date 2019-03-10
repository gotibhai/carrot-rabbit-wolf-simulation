defmodule Simulation.World.LocationAPI do
  @moduledoc """
  This module will be the Location API and other objects will deal with this API.
  """
  require Logger
  use GenServer
  @board_size 5
  alias Simulation.World.Position

  def start_link() do
    Logger.debug("LocationAPI starting")
    GenServer.start_link(__MODULE__, %{used_positions: []} ,name: __MODULE__)
  end

  def init(state) do
    Logger.debug("The state is #{inspect state}")
    {:ok, state}
  end

  def handle_cast({:add, new_positions}, state) do
    {_old, new_state} =
      state
      |> Map.get_and_update!(:used_positions, fn current_value ->
        {current_value, Enum.concat(current_value, new_positions)}
      end)

    {:noreply, new_state}
  end

  def handle_cast({:remove, old_positions}, state) do
    {_old, new_state} =
      state
      |> Map.get_and_update!(:used_positions, fn current_positions ->
        {current_positions, current_positions -- old_positions}
      end)

    {:noreply, new_state}
  end

  def handle_call(:get_empty_positions, _from, state) do
    {:reply, get_empty_positions(state), state}
  end

  def handle_call({:move, cur_pos}, _from, state) do
    {:reply, move_character(cur_pos, state), state}
  end

  @doc """
  This function is responsible for moving a character to a new position.
  """
  def move_character(cur_pos) do
    Logger.debug("Move Character called...")
    GenServer.call(__MODULE__, {:move, cur_pos})
  end

  def move_character(cur_pos, state) do
    Logger.debug("old state : #{inspect state}")
    update_used_positions(:remove, [cur_pos])
    new_position = get_new_position(cur_pos, state)
    Logger.debug("Moving Character to new location: #{inspect new_position}!")
    update_used_positions(:add, [new_position])
    new_position
  end

  defp get_new_position(cur_pos, state) do
    get_neighbouring_locations(cur_pos)
    |> filter_used_positions(state)
    |> Enum.random
  end

  def get_neighbouring_locations(%{lat: x, long: y}) do
    Enum.map(-2..2, fn modifier ->
      [%Position{lat: x+modifier, long: y}, %Position{lat: x, long: y+modifier}, %Position{lat: x, long: y+modifier}]
    end)
    |> Enum.flat_map(&(&1))
    |> Enum.filter(fn %{lat: x, long: y} -> x >= 0 and x <= @board_size and y >= 0 and y <= @board_size end)
    |> Enum.uniq()
  end

  @doc """
  This function is responsible for returning size number of *free* locations.
  """
  def get_locations(size) do
    new_positions =
      GenServer.call(__MODULE__, :get_empty_positions)
      |> Enum.take_random(size)
    update_used_positions(:add, new_positions)
  end

  defp update_used_positions(:add, new_positions) do
    GenServer.cast(__MODULE__, {:add, new_positions})
    new_positions
  end

  defp update_used_positions(:remove, old_positions) do
    GenServer.cast(__MODULE__, {:remove, old_positions})
    old_positions
  end

  defp get_empty_positions(state) do
    get_all_positions()
    |> filter_used_positions(state)
  end

  defp filter_used_positions(provided_positions, state) do
    Enum.filter(provided_positions, fn x -> not Enum.member?(Map.get(state, :used_positions), x) end)
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
