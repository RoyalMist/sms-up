defmodule SmsUp.MixProject do
  use Mix.Project

  def project do
    [
      app: :sms_up,
      version: "0.0.1",
      description: [
        "Lib to use SmsUP api to send sms.",
        "It also provides a pin validation system to verify phone numbers or provide second factor system."
      ],
      source_url: "https://github.com/RoyalMist/sms_up",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SmsUp.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.7"}
    ]
  end
end
