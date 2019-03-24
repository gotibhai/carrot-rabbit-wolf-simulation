defmodule Simulation.Carrots.Carrot do
  require Logger
  alias Simulation.Carrots.{Carrot, CarrotAPI}
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
    #Process.send(CarrotAPI, :update_no_carrots, [])
    GenServer.call(CarrotAPI, :update_no_carrots)
    Logger.debug("I, Carrot, AM GETTING KILLED(eaten)")
    {:noreply, state}
  end
end
