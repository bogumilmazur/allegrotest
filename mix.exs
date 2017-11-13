defmodule Myclient.Mixfile do
  use Mix.Project

  @name    :myclient
  @version "0.1.0"

  @deps [
    {:httpoison, "~> 0.13.0"},
    {:ex_doc, ">= 0.0.0"},
  ]

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env == :prod
    [
      app:     @name,
      version: @version,
      elixir:  ">= 1.5.2",
      deps:    @deps,
      build_embedded:  in_production,
    ]
  end

  def application do
    [
      extra_applications: [         # built-in apps that need starting
        :logger
      ],
    ]
  end

end
