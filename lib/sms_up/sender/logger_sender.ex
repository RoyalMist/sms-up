defmodule SmsUp.Sender.LoggerSender do
  @behaviour SmsUp.Sender.Sender
  alias SmsUp.Numbers.PhoneValidator

  @moduledoc """
  Logger sender usefull for testing and development.
  Do not send a sms but print it in the console.
  """

  @impl SmsUp.Sender.Sender
  def send_sms(international_number, text)
      when is_binary(international_number) and is_binary(text) do
    if PhoneValidator.is_valid_number?(international_number) do
      deliver(international_number, text)
    else
      {:error, "#{international_number} is not a valid number"}
    end
  end

  @impl SmsUp.Sender.Sender
  def send_sms(number, country_code, text)
      when is_binary(number) and is_binary(country_code) and is_binary(text) do
    case PhoneValidator.format(number, country_code) do
      {:ok, number} -> send_sms(number, text)
      error -> error
    end
  end

  defp deliver(to, body) do
    require Logger

    Logger.debug("""
    SMS to : #{to}

    #{body}
    """)

    {:ok, %{to: to, body: body}}
  end
end
