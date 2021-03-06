defmodule Simulation.World.WorldSupervisor do
  require Logger
  use Supervisor

  alias Simulation.World.{LocationAPI, WorldGenerator, WorldAPI}
  def start_link() do
    Logger.debug("Starting World supervisor!")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Logger.debug("Inside the #{__MODULE__} init/1 function!")
    children = [
      supervisor(Simulation.Carrots.CarrotSupervisor, []),
      supervisor(Simulation.Rabbits.RabbitSupervisor, []),
      worker(LocationAPI, []),
      worker(WorldAPI, []),
      worker(WorldGenerator, [])
    ]
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.init(children, opts)
  end
end
