defmodule Simulation.Rabbits.RabbitSupervisor do
  require Logger
  use Supervisor

  alias Simulation.Rabbits.RabbitGenerator
  def start_link() do
    Logger.debug("Starting Rabbit supervisor!")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Logger.debug("Inside the #{__MODULE__} init/1 function!")
    children = [
      %{
        id: RabbitGenerator,
        start: {RabbitGenerator, :start_link, [[]]}
      }
    ]
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.init(children, opts)
  end
end
