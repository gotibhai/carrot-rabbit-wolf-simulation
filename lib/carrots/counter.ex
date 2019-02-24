defmodule Simulation.Carrots.Counter do
  @moduledoc """
  This module is an Agent for the Carrot module.
  It's responsible for maintaining a counter.
  """
  require Logger

  def start_link(_state \\ []) do
    Logger.debug("Counter has started!")
    {:ok, _pid } = Agent.start_link(fn -> 1 end, name: __MODULE__)
  end

  def get_next_count(pid) do
    Agent.get_and_update(pid, fn state -> {state, state + 1} end)
  end
end
