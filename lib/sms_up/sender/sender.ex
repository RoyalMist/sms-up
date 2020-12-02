defmodule SmsUp.Sender.Sender do
  @moduledoc """
  SMS sender behaviour
  """

  @doc """
  Send a sms to the provided number (international format) with the given text.
  """
  @callback send_sms(String.t(), String.t()) :: {:ok, %{to: String.t(), body: String.t()}} | {:error, String.t()}

  @doc """
  Send a sms tot the provided number and country code with the given text.
  """
  @callback send_sms(String.t(), String.t(), String.t()) :: {:ok, %{to: String.t(), body: String.t()}}  | {:error, String.t()}
end
