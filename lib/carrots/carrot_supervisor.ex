defmodule Simulation.Carrots.CarrotSupervisor do
  require Logger
  use Supervisor

  alias Simulation.Carrots.CarrotGenerator
  def start_link() do
    Logger.debug("Starting carrot supervisor!")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Logger.debug("Inside the #{__MODULE__} init/1 function!")
    children = [
      #supervisor(CarrotGenerator, [])
      %{
        id: CarrotGenerator,
        start: {CarrotGenerator, :start_link, [[]]}
      }
    ]
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.init(children, opts)
  end
end
