# Simulation

A textual description:

> We had to implement a simulated world inhabited by carrots, rabbits, and wolves. Rabbits would roam this world eating carrots that grew in random patches. When they had eaten enough carrots, the rabbits would get fat and split in two. Wolves ran around eating up the rabbits; if they managed to catch and eat enough rabbits, they would also get fat and split. Rabbits and wolves within a certain distance of each other would broadcast information on food and predators. If a rabbit found a carrot patch, other rabbits would quickly join him. If a wolf found a rabbit, the pack would start chasing it.

## Initial Thoughts:
1) Carrot patches grow on the board. 

2) Rabbits eat the carrots and rabbits split into 2 as they become really fat.
If the rabbits didn't get enough carrots, it would run out of energy and starve and disappear.

3) Wolves went around on the patch and ate rabbits. 
If they ate too many rabbits, they became fat and split into 2. 

## Intelligent Features:

1) If rabbit found a carrot patch, he would brodcast to all the rabbits in a certain radius to come and eat the carrots. 

2) If Wolves found the rabbit, the rabbits would tell other rabbits to run away and the wolves would tell other wolves to reach and eat some delicious rabbits.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `simulation` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:simulation, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/simulation](https://hexdocs.pm/simulation).

