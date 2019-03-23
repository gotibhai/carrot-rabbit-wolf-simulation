defmodule Simulation.Application do
  @moduledoc """
  This module will start the application
  """
  use Application
  require Logger

  def start(:normal, _start_args) do
    import Supervisor.Spec

    main_viewport_config = Application.get_env(:simulation, :viewport)

    Logger.debug("Application started!")
    children = [
      {Scenic, viewports: [main_viewport_config]},
      supervisor(Simulation.World.WorldSupervisor, [])
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
