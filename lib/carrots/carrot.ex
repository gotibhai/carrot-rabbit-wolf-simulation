defmodule Simulation.Carrots.Carrot do
  require Logger
  alias Simulation.Carrots.Carrot
  alias Simulation.World.Position
  use GenServer
  defstruct name: nil, color: nil, age: nil, position: %Position{}

  def start_link({name, color, age, position}) do
    Logger.debug("Inside #{__MODULE__} start_link/1.")
    GenServer.start_link(
      __MODULE__,
      {name, color, age, position},
      name: name
    )
  end

  def init({name, color, age, position}) do
    {:ok, %Carrot{name: name, color: color, age: age, position: position}}
  end

  def handle_info(:eat, state) do
    Logger.debug("I'M GETTING KILLED(eaten)")
    {:stop, :normal, state}
  end
end
