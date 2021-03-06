defmodule GameOfLife.Mixfile do
  use Mix.Project

  def project do
    [
      app: :game_of_life,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {GameOfLife.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end
end
