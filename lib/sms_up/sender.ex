defmodule SmsUp.Sender do
  alias SmsUp.Numbers.PhoneValidator
  @deliver_module Application.get_env(:sms_up, :deliver_module, SmsUp.Delivery.LoggerDelivery)

  @moduledoc """
  SMS sender api that can accept a configurable deliver for sending successfull messages.
  """

  @spec send_sms(String.t(), String.t()) ::
          {:error, String.t()} | {:ok, %{body: String.t(), to: String.t()}}
  def send_sms(number, text) when is_binary(number) and is_binary(text) do
    if PhoneValidator.is_valid_number?(number) do
      deliver(number, text)
    else
      {:error, "#{number} is not a valid number"}
    end
  end

  @spec send_sms(String.t(), String.t(), String.t()) ::
          {:error, String.t()} | {:ok, %{body: String.t(), to: String.t()}}
  def send_sms(number, country_code, text)
      when is_binary(number) and is_binary(country_code) and is_binary(text) do
    case PhoneValidator.format(number, country_code) do
      {:ok, number} -> send_sms(number, text)
      error -> error
    end
  end

  @doc false
  defdelegate deliver(number, text), to: @deliver_module
end
