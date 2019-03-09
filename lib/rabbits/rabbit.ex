defmodule Simulation.Rabbits.Rabbit do
  require Logger
  alias Simulation.Rabbits.Rabbit
  alias Simulation.World.Position
  use GenServer
  defstruct name: nil, weight: nil, age: nil, position: %Position{}

  def start_link({name, weight, age, position}) do
    Logger.debug("Inside #{__MODULE__} start_link/1.")
    GenServer.start_link(
      __MODULE__,
      {name, weight, age, position},
      name: :"rabbit_#{name}"
      )
  end

  def init({name, weight, age, position}) do
    {:ok, %Rabbit{name: name, weight: weight, age: age, position: position}}
  end

  def handle_cast(:eat, state) do
    Logger.debug("Inside handle cast")
    kill_myself()
    {:no_reply, state}
  end

  def kill_myself() do
    Logger.debug("Killing myself now!")
    Process.exit(self(), :dead)
  end
end
