defmodule Simulation.Application do
  @moduledoc """
  This module will start the application
  """
  use Application
  require Logger

  def start(:normal, _start_args) do
    import Supervisor.Spec

    Logger.debug("Application started!")
    children = [supervisor(Simulation.Carrots.Supervisor, [])]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
