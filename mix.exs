defmodule EscriptDemo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :le_etoile,
      version: "0.1.0",
      elixir: "~> 1.5",
      escript: [main_module: Etoile.Cli],
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:bunt, "~> 0.1.0"},
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      { :elixir_uuid, "~> 1.2" }
    ]
  end
end
