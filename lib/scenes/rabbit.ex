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

  @rabbit_width 40
  @rabbit_height 30

  def init(first_scene, opts) do
    viewport = opts[:viewport]

    # calculate the transform that centers the parrot in the viewport
    {:ok, %ViewPort.Status{size: {vp_width, vp_height}}} = ViewPort.info(viewport)

    position = {
      vp_width / 2 - @rabbit_width / 2,
      vp_height / 2 -  @rabbit_height / 2
    }

    # load the rabbit texture into the cache
    Scenic.Cache.File.load(@rabbit_path, @rabbit_hash)

    graph = Graph.build()
    |> rect({vp_width, vp_height}, fill: :white)
    |> rect(
      {@rabbit_width, @rabbit_height},
      id: :rabbit,
      fill: {:image, @rabbit_hash}
    )
    |> Graph.modify(:rabbit, &update_opts(&1, translate: position))
    |> push_graph()

    state = %{
      viewport: viewport,
      graph: graph,
      first_scene: first_scene,
      alpha: 0
    }

    {:ok, state}
  end
end
