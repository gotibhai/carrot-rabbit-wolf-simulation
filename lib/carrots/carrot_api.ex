defmodule Simulation.Carrots.CarrotAPI do
  @moduledoc """
  This module is the generator of Carrots.
  """
  require Logger
  use Supervisor
  alias Simulation.Carrots.{Carrot, Counter}
  alias Simulation.World.{LocationAPI, Position}
  @carrot_patch_size 50

  def start_link(state \\ []) do
    Logger.debug("Inside #{__MODULE__} start_link/1")
    DynamicSupervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    Logger.debug("Inside #{__MODULE__} Init")
    {:ok, _pid} = Counter.start_link()
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp create_a_name() do
    :"carrot_c#{Counter.get_next_count(Counter)}"
  end

  defp create_a_carrot(position) do
    name = create_a_name()
    color = "Orange"
    age = 1
    child_spec = %{
      id: Carrot,
      restart: :temporary,
      start: {Carrot, :start_link, [{name, color, age, position}]}
    }
    LocationAPI.update_occupancy(name, position)
    {:ok, _agent1} = DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  This function will create a carrot patch.
  Carrot patch: These are of @carrot_patch_size number of carrots made together!
  """
  def create_a_carrot_patch() do
    carrot_locations = LocationAPI.get_locations(@carrot_patch_size)
    Enum.each(0..@carrot_patch_size-1, fn(x) ->
      create_a_carrot(Enum.at(carrot_locations, x))
    end)
    :ok
  end
end
