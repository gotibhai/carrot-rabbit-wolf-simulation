defmodule Simulation.World.WorldGenerator do
  @moduledoc """
  This module is responsible for creating the initial state of the world.
  """
  require Logger
  use GenServer
  alias Simulation.Carrots.CarrotGenerator
  alias Simulation.Rabbits.RabbitGenerator

  def start_link() do
    Logger.debug("WorldGenerator starting")
    GenServer.start_link(__MODULE__, :ok ,name: __MODULE__)
  end

  def init(args) do
    initialize_state()
    {:ok, args}
  end

  def initialize_state() do
    CarrotGenerator.create_a_carrot_patch()
    RabbitGenerator.create_rabbits()
  end
end