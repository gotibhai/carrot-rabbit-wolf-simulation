defmodule Simulation.World.LocationAPI do
  @moduledoc """
  This module will be the Location API and other objects will deal with this API.
  """
  require Logger
  use GenServer
  @board_size 4
  alias Simulation.World.Position

  def start_link() do
    Logger.debug("LocationAPI starting")
    GenServer.start_link(__MODULE__, %{used_positions: [], occupancy: %{}} ,name: __MODULE__)
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

  def handle_cast({:add_occupancy, name, position}, state) do
    {:noreply, add_occupancy(state, name, position)}
  end

  def handle_cast({:remove_occupancy, position}, state) do
    {:noreply, remove_occupancy(state, position)}
  end

  def handle_call({:get_occupancy, position}, _from, state) do
    new_state =
      case get_occupancy(state, position) do
        nil -> nil
        char -> {:ok, char}
      end
    {:reply, new_state, state}
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
    GenServer.call(__MODULE__, {:move, cur_pos})
  end

  def move_character(cur_pos, state) do
    update_used_positions(:remove, [cur_pos])
    new_position = get_new_position(cur_pos)
    Logger.debug("Moving Character to new location: #{inspect new_position}")
    Logger.debug("Occupant of the this new location: #{get_in(state, [:occupancy, new_position])}")
    update_used_positions(:add, [new_position])
    new_position
  end

  defp get_new_position(cur_pos) do
    get_neighbouring_locations(cur_pos)
    |> Enum.random
  end

  def get_neighbouring_locations(%{lat: x, long: y}) do
    Enum.map(-2..2, fn modifier ->
      [%Position{lat: x+modifier, long: y}, %Position{lat: x, long: y+modifier}, %Position{lat: x+modifier, long: y+modifier}]
    end)
    |> Enum.flat_map(&(&1))
    |> Enum.filter(fn %{lat: x, long: y} -> x >= 0 and x <= @board_size and y >= 0 and y <= @board_size end)
    |> Enum.uniq()
  end

  def who_lives_here(position) do
    GenServer.call(__MODULE__, {:get_occupancy, position})
  end

  @doc """
  This function is responsible for updating the occupancy dictionary.
  """
  def update_occupancy(name, position) do
    #Logger.info("Adding Occupancy")
    GenServer.cast(__MODULE__, {:add_occupancy, name, position})
  end

  def update_occupancy(position) do
    #Logger.info("Removing Occupancy")
    GenServer.cast(__MODULE__, {:remove_occupancy, position})
  end

  defp add_occupancy(state, name, position) do
    put_in(state, [:occupancy, position], name)
  end

  defp remove_occupancy(state, position) do
    # Logger.debug("Inside remove occupancy, REMOVING #{inspect position}")
    # Logger.debug("State is #{inspect state}")
    pop_in(state, [:occupancy, position]) |> elem(1)
  end

  defp get_occupancy(state, position) do
    get_in(state, [:occupancy, position])
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

  defp update_used_positions(action, new_positions) do
    GenServer.cast(__MODULE__, {action, new_positions})
    new_positions
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
