defmodule SmsUp.Delivery.SmsUpDelivery do
  @behaviour SmsUp.Delivery

  def deliver(to, body) do
    # TODO
    {:ok, %{to: to, body: body}}
  end

  defp get_api_key do
    Application.get_env(:sms_up, :api_key, "SET_ME")
  end
end
