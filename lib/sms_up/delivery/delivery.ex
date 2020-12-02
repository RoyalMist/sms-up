defmodule SmsUp.Delivery do
  @moduledoc """
  SMS delivery behaviour.
  """

  @doc """
  Deliver the sms to the selected provider.
  """
  @callback deliver(String.t(), String.t()) :: {:ok, %{to: String.t(), body: String.t()}} | {:error, String.t()}
end
