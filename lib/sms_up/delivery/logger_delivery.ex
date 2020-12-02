defmodule SmsUp.Delivery.LoggerDelivery do
  @behaviour SmsUp.Delivery

  @impl true
  @spec deliver(String.t(), String.t()) :: {:ok, %{body: String.t(), to: String.t()}}
  def deliver(to, body) do
    require Logger

    Logger.debug("""
    SMS to : #{to}

    #{body}
    """)

    {:ok, %{to: to, body: body}}
  end
end
