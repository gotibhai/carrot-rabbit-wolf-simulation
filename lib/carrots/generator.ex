defmodule Simulation.Carrots.Generator do
  require Logger
  use GenServer
  alias Simulation.Carrots.Carrot
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Logger.debug("Inside Init")
    {:ok, state}
  end
  def create_a_carrot() do
    Task.start_link(fn -> Carrot.stay_alive(%Carrot{name: "c", color: "orange", age: 1}) end)
  end

end
