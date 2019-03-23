defmodule Simulation.Scenes.Rabbit do
  @moduledoc """
  Sample splash scene.

  This scene demonstrate a very simple animation and transition to another scene.

  It also shows how to load a static texture and paint it into a rectangle.
  """
  use Scenic.Scene
  alias Scenic.Graph
  alias Scenic.ViewPort
  import Scenic.Primitives, only: [{:rect, 3}, {:update_opts, 2}]

  @rabbit_path :code.priv_dir(:simulation)
              |> Path.join("/static/images/small_rabbit.png")
  @rabbit_hash Scenic.Cache.Hash.file!( @rabbit_path, :sha )

  @rabbit_width 62
  @rabbit_height 114

  @graph Graph.build()
        |> rect(
          {@rabbit_width, @rabbit_height},
          id: :rabbit,
          fill: {:image, {@rabbit_hash, 0}}
        )

  @animate_ms 30
  @finish_delay_ms 1000

  def init(first_scene, opts) do
    viewport = opts[:viewport]

    # calculate the transform that centers the parrot in the viewport
    {:ok, %ViewPort.Status{size: {vp_width, vp_height}}} = ViewPort.info(viewport)

    position = {
      vp_width / 2 - @rabbit_width / 2,
      vp_height / 2 -  @rabbit_height / 2
    }

    # load the parrot texture into the cache
    Scenic.Cache.File.load(@rabbit_path, @rabbit_hash)

    # move the parrot into the right location
    graph =
      Graph.modify(@graph, :rabbit, &update_opts(&1, translate: position))
      |> push_graph()

    # # start a very simple animation timer
    {:ok, timer} = :timer.send_interval(@animate_ms, :animate)

    state = %{
      viewport: viewport,
      timer: timer,
      graph: graph,
      first_scene: first_scene,
      alpha: 0
    }

    {:ok, state}
  end

  def handle_info(
        :animate,
        %{timer: timer, alpha: a} = state
      )
      when a >= 256 do
    :timer.cancel(timer)
    Process.send_after(self(), :finish, @finish_delay_ms)
    {:noreply, state}
  end

  def handle_info(:finish, state) do
    {:noreply, state}
  end

  def handle_info(:animate, %{alpha: alpha, graph: graph} = state) do
    graph =
      graph
      |> Graph.modify(:rabbit, &update_opts(&1, fill: {:image, {@rabbit_hash, alpha}}))
      |> push_graph()

    {:noreply, %{state | graph: graph, alpha: alpha + 2}}
  end

end
