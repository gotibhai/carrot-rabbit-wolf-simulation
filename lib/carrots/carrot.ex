defmodule Simulation.Carrots.Carrot do
  require Logger
  alias Simulation.Carrots.Carrot
  defstruct name: nil, color: nil, age: nil

  def stay_alive(carrot) do
    receive do
      {:hello, value} ->
        Logger.debug(value)
        stay_alive(carrot)
    end
  end
end
