defmodule SmsUp.MixProject do
  use Mix.Project

  def project do
    [
      app: :sms_up,
      elixir: "~> 1.11",
      version: "1.2.1",
      source_url: "https://github.com/RoyalMist/sms-up",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      dialyzer: [plt_add_deps: :app_tree]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {SmsUp.Application, []}
    ]
  end

  defp deps do
    [
      {:memento, "~> 0.3"},
      {:httpoison, "~> 1.8"},
      {:ex_phone_number, "~> 0.2"},
      {:ex_doc, "~> 0.26", runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.11", only: [:dev, :test], runtime: false},
      {:mix_audit, "~> 2.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp description() do
    "Lib to use SmsUP api to send sms. It also provides a pin validation system to verify phone numbers or provide second factor system."
  end

  defp package() do
    [
      name: "sms_up",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/RoyalMist/sms-up"}
    ]
  end
end
