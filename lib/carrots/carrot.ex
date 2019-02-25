defmodule Simulation.Carrots.Carrot do
  require Logger
  alias Simulation.Carrots.Carrot
  alias Simulation.World.Position
  use GenServer
  defstruct name: nil, color: nil, age: nil, position: %Position{}

  def start_link({name, color, age, position}) do
    Logger.debug("Inside #{__MODULE__} start_link/1. Name: #{name}, Color: #{color}, Age:#{age} and position")
    IO.inspect position
    GenServer.start_link(
      __MODULE__,
      {name, color, age, position},
      name: :"carrot_#{name}"
      )
  end

  def init({name, color, age, position}) do
    Logger.debug("Inside #{__MODULE__} init/1")
    {:ok, %Carrot{name: name, color: color, age: age, position: position}}
  end
end
