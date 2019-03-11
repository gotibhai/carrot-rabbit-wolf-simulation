defmodule Simulation.Rabbits.RabbitAPI do
  @moduledoc """
  This module is the generator of Rabbits. TODO: Rename this to RabbitAPI
  """
  require Logger
  use Supervisor
  alias Simulation.Rabbits.{Rabbit, Counter}
  alias Simulation.World.{LocationAPI}
  @rabbit_population 10

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(state \\ []) do
    Logger.debug("Inside #{__MODULE__} start_link/1")
    DynamicSupervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    Logger.debug("Inside #{__MODULE__} Init")
    {:ok, _pid} = Counter.start_link()
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp get_all_rabbits() do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_a,b,_c,_d} -> Process.info(b) end)
    |> Enum.map(&(Enum.at(&1, 0)))
    |> Enum.map(fn {_a,b} -> b end)
  end

  defp create_a_name() do
    :"rabbit_r#{Counter.get_next_count(Counter)}"
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
    LocationAPI.update_occupancy(name, position)
    {:ok, _agent1} = DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  This function will create the rabbit population.
  """
  def create_rabbits() do
    rabbit_locations = LocationAPI.get_locations(@rabbit_population)
    Enum.each(0..@rabbit_population-1, fn(x) ->
      create_a_rabbit(Enum.at(rabbit_locations, x))
    end)
  end

  @doc """
  This function is responsible for calling each rabbit and telling
  it to move.
  """
  def move_all_rabbits() do
    get_all_rabbits()
    |> Enum.map(&(Rabbit.move_rabbit(&1)))
  end
end
