defmodule Simulation.Scenes.Home do
  use Scenic.Scene

  alias Scenic.Graph
  alias Scenic.ViewPort

  import Scenic.Primitives
  # import Scenic.Components

  @font_size 35
  @shift 150

  require Logger
  def init(_, opts) do
    {:ok, %ViewPort.Status{size: {vp_width, _}}} =
    opts[:viewport]
    |> ViewPort.info()

    graph = Graph.build(font: :roboto, font_size: 16, theme: :dark)
    |> group(
      fn graph ->
        graph
        |> text(
          "Num Rabbits: ",
          id: :num_rabbits_title,
          text_align: :center,
          font_size: @font_size,
          translate: {vp_width / 2, @font_size}
        )
        |> text(
          "",
          id: :num_rabbits_value,
          text_align: :right,
          font_size: @font_size,
          translate: {(vp_width / 2) + @shift, @font_size}
        )
      end
    )

    state = %{
      graph: graph,
      rabbits: %{
        num_rabbits: 0
      }
    }

    push_graph(graph)
    {:ok, state}
  end

  def filter_event({:num_rabbits, value}, %{graph: graph}) do
    Logger.info("REACHING FILTER EVENT")
    graph = graph
    |> Graph.modify(:num_rabbits_value, &text(&1, value))
    |> push_graph()

    {:continue, value, graph}
  end

  def handle_call({:num_rabbits, value}, _from, state) do
    Logger.info("Reaching here...... LMAO")
    Scenic.Scene.send_event(__MODULE__, {:num_rabbits, state})
    {:noreply, update_num_rabbits(state, value)}
  end

  def update_num_rabbits(state, value) do
    put_in(state, [:rabbits, :num_rabbits], value)
  end
end
