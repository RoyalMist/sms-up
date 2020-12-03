defmodule SmsUp.Sender do
  alias SmsUp.Numbers.PhoneValidator

  @moduledoc """
  SMS sender api that can accept a configurable deliver for sending successfull messages.
  """

  @doc """
  Send a sms with the chosen Sender Module.
  Configuration is available as :
  `
  config :sms_up, deliver_module: MODULE
  `
  MODULE can be:
  * SmsUp.Delivery.LoggerDelivery (default)
  * SmsUp.Delivery.SmsUpDelivery.

  Returns a ok tuple containing the message body and the number for which it was sent to or an error tuple with the reason.

  ## Examples

      iex> SmsUp.send_sms("+41765556677", "message", [])
      {:ok, %{to: "+41765556677", body: "message", options: []}}

      iex> SmsUp.send_sms("Hello", "FR", [])
      {:error, "Hello is not a valid number"}
  """
  @spec send_sms(String.t(), String.t(), Keyword.t()) ::
          {:error, String.t()} | {:ok, %{body: String.t(), to: String.t()}}
  def send_sms(number, text, options) when is_binary(number) and is_binary(text) do
    if PhoneValidator.is_valid_number?(number) do
      deliver(number, text, options)
    else
      {:error, "#{number} is not a valid number"}
    end
  end

  @doc """
  Send a sms with the chosen Sender Module.
  Configuration is available as :
  `
  config :sms_up, deliver_module: MODULE
  `
  MODULE can be:
  * SmsUp.Delivery.LoggerDelivery (default)
  * SmsUp.Delivery.SmsUpDelivery.

  Returns a ok tuple containing the message body and the number for which it was sent to or an error tuple with the reason.

  ## Examples

      iex> SmsUp.send_sms("0765556677", "CH", "message", [])
      {:ok, %{to: "+41765556677", body: "message", options: []}}

      iex> SmsUp.send_sms("0630772288", "ZZ", "message", [])
      {:error, "Invalid country calling code"}

      iex> SmsUp.send_sms("Hello", "FR", "message", [])
      {:error, "The string supplied did not seem to be a phone number"}
  """
  @spec send_sms(String.t(), String.t(), String.t(), Keyword.t()) ::
          {:error, String.t()} | {:ok, %{body: String.t(), to: String.t()}}
  def send_sms(number, country_code, text, options)
      when is_binary(number) and is_binary(country_code) and is_binary(text) do
    case PhoneValidator.format(number, country_code) do
      {:ok, number} -> send_sms(number, text, options)
      error -> error
    end
  end

  @doc false
  defdelegate deliver(number, text, options), to: Application.get_env(:sms_up, :deliver_module, SmsUp.Delivery.LoggerDelivery)
end
