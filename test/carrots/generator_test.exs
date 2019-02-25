defmodule GeneratorTest do
  use ExUnit.Case
  alias Simulation.Carrots.Generator

  test "create_a_carrot works" do
    {:ok, pid} = Generator.create_a_carrot()
    assert Process.alive?(pid) == true
    IO.inspect(Process.info(pid))
  end
end
