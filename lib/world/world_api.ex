defmodule Simulation.World.WorldAPI do
  @moduledoc """
  This module will be the world API and other objects will deal with this API.

  Movement module.
    * Concept of time will be defined by this module.
    * When asked to move, it will reach out Rabbit module and move each rabbit.

  """
  require Logger
  use GenServer
  alias Simulation.Rabbits.RabbitAPI

  @time_interval 1000

  def start_link() do
    Logger.debug("WorldAPI starting")
    GenServer.start_link(__MODULE__, %{} ,name: __MODULE__)
  end

  def init(state) do
    Logger.debug("The state is #{inspect state}")
    {:ok, state}
  end

  def handle_info(:start_movement, state) do
    RabbitAPI.move_all_rabbits()
    start_movement() # Reschedule once more
    {:noreply, state}
  end

  def start_movement() do
      Process.send_after(self(), :start_movement, @time_interval)
  end
end
