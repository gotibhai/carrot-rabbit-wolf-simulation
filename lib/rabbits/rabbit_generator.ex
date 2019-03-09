defmodule Simulation.Rabbits.RabbitGenerator do
  @moduledoc """
  This module is the generator of Rabbits.
  """
  require Logger
  use Supervisor
  alias Simulation.Rabbits.{Rabbit, Counter}
  alias Simulation.World.{WorldAPI, Position}
  @rabbit_population 5

  def start_link(state \\ []) do
    Logger.debug("Inside #{__MODULE__} start_link/1")
    DynamicSupervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    Logger.debug("Inside #{__MODULE__} Init")
    {:ok, _pid} = Counter.start_link()
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_a_name() do
    :"r#{Counter.get_next_count(Counter)}"
  end

  defp create_a_rabbit(position) do
    name = create_a_name()
    weight = 1
    age = 1
    child_spec = %{
      id: Rabbit,
      restart: :temporary,
      start: {Rabbit, :start_link, [{name, weight, age, position}]}
    }
    {:ok, _agent1} = DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  This function will create the rabbit population.

  """
  def create_rabbits() do
    rabbit_locations = WorldAPI.get_locations(@rabbit_population)
    Enum.each(0..@rabbit_population-1, fn(x) ->
      create_a_rabbit(Enum.at(rabbit_locations, x))
    end)
  end
end
