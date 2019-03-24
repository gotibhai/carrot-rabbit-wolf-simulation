defmodule Simulation.Scenes.Home do
  use Scenic.Scene

  alias Scenic.Graph
  alias Scenic.ViewPort

  import Scenic.Primitives
  # import Scenic.Components

  @font_size 16
  @shift 50

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
          translate: {30 , @font_size}
        )
        |> text(
          "",
          id: :num_rabbits_value,
          translate: {70 + @shift, @font_size}
        )
        end
      )
    |> group(
      fn graph ->
        graph
        |> text(
          "Num Carrots: ",
          id: :num_carrots_title,
          translate: {150, @font_size}
        )
        |> text(
          "",
          id: :num_carrots_value,
          text_align: :right,
          translate: {200 + @shift, @font_size}
        )
      end
    )

    state = %{
      graph: graph
    }

    push_graph(graph)
    Process.register(self(), __MODULE__)
    {:ok, state}
  end

  def handle_cast({:num_rabbits, value}, %{graph: graph} = state) do
    graph = graph
      |> Graph.modify(:num_rabbits_value, &text(&1, value))
      |> push_graph()
    {:noreply, %{state | graph: graph}}
  end

  def handle_cast({:num_carrots, value}, %{graph: graph} = state) do
    graph = graph
      |> Graph.modify(:num_carrots_value, &text(&1, value))
      |> push_graph()
    {:noreply, %{state | graph: graph}}
  end
end
