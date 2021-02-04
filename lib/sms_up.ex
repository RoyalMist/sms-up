defmodule SmsUp do
  @moduledoc """
  SmsUp is used to send sms throught [SmsUP](https://smsup.ch) (other api may be integrated easily) by implementing the same behaviour.
  This module provides delegates to the internal modules for sending sms and the distributed One Time Password store.
  For the One Time Password functionality if you are part of a cluster the librairy uses mnesia to distibute the store accross the nodes.
  """

  @doc """
  Generate a pin code for the given id and store it in a mnesia database.
  Returns the generated pin code.

  ## Examples

      iex> SmsUp.store("user@email.ch")
      "123456"
  """
  @spec store(any) :: String.t()
  defdelegate store(id), to: SmsUp.Pin.Store

  @doc """
  Validate a pin code along with the user id and tells if the provided pin is correct or not.
  Returns a tupple containing true or false regarding the result.

  ## Examples
      iex> SmsUp.validate("user@email.ch", "Good Pin")
      {:ok, true}

      iex> SmsUp.validate("user@email.ch", "Wrong Pin")
      {:ok, false}
  """
  @spec validate(any, binary) :: {:ok, true} | {:ok, false}
  defdelegate validate(id, pin), to: SmsUp.Pin.Store

  @doc """
  Send a sms with the chosen Sender Module.
  Configuration is available as :
  `
  config :sms_up, :deliver_module, MODULE
  `
  MODULE can be SmsUp.Delivery.LoggerDelivery (default) or SmsUp.Delivery.SmsUpDelivery.

  Returns a ok tuple containing the message body and the number for which it was sent to or an error tuple with the reason.

  ## Examples

      iex> SmsUp.send_sms("+41765556677", "message")
      {:ok, %{to: "+41765556677", body: "message"}}
  """
  @spec send_sms(String.t(), String.t(), Keyword.t()) ::
          {:error, String.t()} | {:ok, %{body: String.t(), to: String.t()}}
  defdelegate send_sms(number, text, options \\ []), to: SmsUp.Sender
end
