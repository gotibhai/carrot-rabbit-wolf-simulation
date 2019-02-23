defmodule Simulation.Carrots.Supervisor do
  require Logger
  use Supervisor

  alias Simulation.Carrots.Generator
  def start_link() do
    Logger.debug("Starting carrot supervisor!")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_params) do
    children = [
      supervisor(Generator, [name: CarrotGenerator]),
    ]
    supervise(children, strategy: :one_for_one, max_restart: 1, max_seconds: 60)
  end
end
