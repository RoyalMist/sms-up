defmodule SmsUp.Delivery.LoggerDelivery do
  @behaviour SmsUp.Delivery

  def deliver(to, body) do
    require Logger

    Logger.debug("""
    SMS to : #{to}

    #{body}
    """)

    {:ok, %{to: to, body: body}}
  end
end
