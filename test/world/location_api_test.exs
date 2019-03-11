defmodule Simulation.World.LocationAPITest do
  use ExUnit.Case
  alias Simulation.World.{LocationAPI, Position}
  @board_size 2
  @character_population 5
  # [%Position{lat: 0,long: 0}, %Position{lat: 0,long: 1}, %Position{lat: 1,long: 0}, %Position{lat: 1,long: 1}]

  # test "get_all_positions/0 should return all possible positions on a 2D board" do
  #   assert LocationAPI.get_locations(@character_population) == []
  # end
end
