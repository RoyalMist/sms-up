defmodule SmsUp.Delivery.SmsUpDelivery do
  @behaviour SmsUp.Delivery

  @impl true
  @spec deliver(String.t(), String.t()) :: {:ok, %{body: String.t(), to: String.t()}}
  def deliver(to, body) do
    # TODO
    {:ok, %{to: to, body: body}}
  end

  defp get_api_key do
    Application.get_env(:sms_up, :api_key, "SET_ME")
  end
end
