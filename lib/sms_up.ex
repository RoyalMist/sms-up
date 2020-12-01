defmodule SmsUp do
  @moduledoc """
  Documentation for `SmsUp`.
  """

  @doc """
  Generate a pin code for the given id and store it in a mnesia database.
  Returns the generated pin code.

  ## Examples

      iex> SmsUp.store("user@email.ch")
      {:ok, "123456"}
  """
  @spec store(any) :: {:error, binary} | {:ok, binary}
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
  @spec validate(any, binary) :: {:ok, boolean}
  defdelegate validate(id, pin), to: SmsUp.Pin.Store
end
