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
  It is also possible to pass force_error to simulate a delivery failure

  ## Examples

      iex> SmsUp.Delivery.LoggerDelivery.deliver("+41765556677", "Hello")
      {:ok, %{to: "+41765556677", body: "Hello", options: []}}

      iex> SmsUp.Delivery.LoggerDelivery.deliver("+41765556677", "Hello", option: 1)
      {:ok, %{to: "+41765556677", body: "Hello", options: [option: 1]}}

      iex> SmsUp.Delivery.LoggerDelivery.deliver("+41765556677", "Hello", force_error: "Ooops")
      {:error, "Ooops"}
  """
  @impl true
  @spec deliver(String.t(), String.t(), Keyword.t()) ::
          {:ok, %{body: String.t(), to: String.t(), options: Keyword.t()}}
          | {:error, String.t()}
  def deliver(to, body, options \\ []) when is_binary(to) and is_binary(body) do
    options_to_print =
      for {k, v} <- options do
        "#{k}: #{v} "
      end

    case Keyword.get(options, :force_error) do
      nil ->
        Logger.info("""
        SMS
        To : #{to}
        Body: #{body}
        #{options_to_print}
        """)

        {:ok, %{to: to, body: body, options: options}}

      value ->
        {:error, value}
    end
  end
end
