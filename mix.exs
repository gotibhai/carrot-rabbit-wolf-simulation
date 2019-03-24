defmodule Simulation.MixProject do
  use Mix.Project

  def project do
    [
      app: :simulation,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      build_embedded: true
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Simulation.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scenic, "~> 0.9"},
      {:scenic_driver_glfw, "~> 0.9", targets: :host},
    ]
  end
end
