defmodule SmsUp.Delivery.SmsUpDelivery do
  @behaviour SmsUp.Delivery

  def deliver(to, body) do
    require Logger

    Logger.debug("""
    SMS to : #{to}
    Message : #{body}
    """)

    {:ok, %{to: to, body: body}}
  end
end
