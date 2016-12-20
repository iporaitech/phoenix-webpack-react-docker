defmodule Core.Mixfile do
  use Mix.Project

  def project do
    [app: :core,
     version: "0.3.4",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Core, []},
      applications: applications(Mix.env)
    ]
  end
  # TODO: add specific packages for test env
  def applications(env) when env in [:test] do
    applications(:default) ++ [:ex_machina]
  end
  def applications(_) do
    [
      :phoenix,
      :phoenix_html,
      :cowboy,
      :logger,
      :gettext,
      :phoenix_ecto,
      :postgrex
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.8"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.13"},
     {:cowboy, "~> 1.0"},
     {:comeonin, "~> 2.4"},
     {:guardian, "~> 0.13.0"},
     {:guardian_db, "~> 0.7"},
     {:canada, "~> 1.0.0"},
     {:absinthe_relay, "~> 1.2"},
     {:absinthe_plug, "~> 1.2"},
     #test packages
     {:espec_phoenix, "~> 0.6.0", only: :test, app: false},
     {:mix_test_watch, "~> 0.2", only: :test},
     {:ex_machina, "~> 1.0", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "spec": ["ecto.create --quiet", "ecto.migrate", "espec"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
