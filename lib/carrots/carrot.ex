defmodule Simulation.Carrots.Carrot do
  require Logger
  alias Simulation.Carrots.Carrot
  use GenServer
  defstruct name: nil, color: nil, age: nil

  def stay_alive(carrot) do
    Logger.debug("Inside #{__MODULE__} stay_alive/1")
    receive do
      {:hello, value} ->
        Logger.debug(value)
        stay_alive(carrot)
    end
  end

  def start_link({name, color, age}) do
    Logger.debug("Inside #{__MODULE__} start_link/1. Name: #{name}, Color: #{color}, Age:#{age}")
    GenServer.start_link(
      __MODULE__,
      {name, color, age},
      name: :"carrot_#{name}"
      )
  end

  def init({name, color, age}) do
    Logger.debug("Inside #{__MODULE__} init/1. Name: #{name}, Color: #{color}, Age:#{age}")
    {:ok, %Carrot{name: name, color: color, age: age}}
  end

  def handle_call(:testing, _from, state) do
    {:reply, :testing_complete, state}
  end
end
