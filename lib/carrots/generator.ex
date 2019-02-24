defmodule Simulation.Carrots.Generator do
  @moduledoc """
  This module is the generator of Carrots.
  """
  require Logger
  use Supervisor
  alias Simulation.Carrots.{Carrot, Counter}

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
    value = Counter.get_next_count(Counter)
    Logger.debug("Value is #{value}")
    :"carrot#{value}"
  end

  @doc """
  This function should return a process which is initialized with a carrot object.
  """
  def create_a_carrot() do
    name = create_a_name()
    color = "Red"
    age = 1
    child_spec = {Carrot, {name, color, age}}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
