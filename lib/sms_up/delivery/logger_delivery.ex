defmodule SmsUp.Delivery.LoggerDelivery do
  @behaviour SmsUp.Delivery
  require Logger

  @moduledoc """
  Print the sms to the console and do not send it to any API.
  Usefull for dev environment and testing.
  """

  @doc """
  Deliver the SMS to the console.
  Provide a valid international number, the body of the message and
  a optional list of options (mostly used by real sms api).

  ## Examples

      iex> SmsUp.Delivery.LoggerDelivery.deliver("+41765556677", "Hello")
      {:ok, %{to: "+41765556677", body: "Hello", options: []}}

      iex> SmsUp.Delivery.LoggerDelivery.deliver("+41765556677", "Hello", [option: 1])
      {:ok, %{to: "+41765556677", body: "Hello", options: [option: 1]}}
  """
  @impl true
  @spec deliver(String.t(), String.t(), Keyword.t()) ::
          {:ok, %{body: String.t(), to: String.t(), options: Keyword.t()}}
  def deliver(to, body, options \\ []) when is_binary(to) and is_binary(body) do
    options_to_print =
      for {k, v} <- options do
        "#{k}: #{v} "
      end

    Logger.debug("""
    SMS
    To : #{to}
    Body: #{body}
    #{options_to_print}
    """)

    {:ok, %{to: to, body: body, options: options}}
  end
end
