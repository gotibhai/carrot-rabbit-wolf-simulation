defmodule Simulation.Rabbits.Rabbit do
  require Logger
  alias Simulation.Rabbits.Rabbit
  alias Simulation.World.{Position, LocationAPI}
  use GenServer
  defstruct name: nil, weight: nil, age: nil, position: %Position{}

  def start_link({name, weight, age, position}) do
    Logger.debug("Inside #{__MODULE__} start_link/1.")
    GenServer.start_link(
      __MODULE__,
      {name, weight, age, position},
      name: name
    )
  end

  def init({name, weight, age, position}) do
    {:ok, %Rabbit{name: name, weight: weight, age: age, position: position}}
  end

  @doc """
  This function is responsible for moving the rabbit.
  """
  def move_rabbit(rabbit_name) do
    case Process.whereis(rabbit_name) do
      nil -> Logger.debug("#{rabbit_name} is dead and I'm skipping to the next rabbit.")
      _pid -> GenServer.call(rabbit_name, {:move, rabbit_name})
    end
  end

  def handle_call({:move, rabbit_name}, _from, state) do
    Logger.debug("Making a move for rabbit. #{inspect state}")
    new_position = LocationAPI.move_character(Map.fetch!(state, :position))
    handle_movement(state, rabbit_name, new_position)
    {:reply, new_position, Map.put(state, :position, new_position)}
  end


  def handle_movement(state, rabbit_name, new_position) do
    Logger.debug("Handling movement")
    old_occupant = LocationAPI.who_lives_here(new_position)
    case old_occupant do
      #Fixme: Right now, I'm killing the character. With wolf, need to check who it is.
      {:ok, char_name} -> eat(rabbit_name, char_name)
      nil -> nil
    end
    LocationAPI.update_occupancy(Map.fetch!(state, :position))
    LocationAPI.update_occupancy(Map.fetch!(state, :name), new_position)
  end

  defp eat(rabbit_name, char_name) do
    Logger.debug("Hello, I'm #{rabbit_name} and I'm tryna eat #{char_name} rn")
    case rabbit_name != char_name do
      true -> Process.send(char_name, :eat, [])
      false -> nil
    end
  end

  def handle_info(:eat, state) do
    Logger.debug("I'M GETTING KILLED(eaten)")
    {:stop, :normal, state}
  end
end
