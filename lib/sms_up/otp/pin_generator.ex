defmodule SmsUp.Otp.PinGenerator do
  @moduledoc """
    This module provides function to create some pin to be verified later after sms is sent.
  """

  @doc """
    Generate a random pin number of the given length (min: 1, max: 10).

    Returns a pin of the given length as a string.

    ## Exemples

    iex> SmsUp.Otp.PinGenerator.generate_pin()
    {:ok, "012345"}

    iex> SmsUp.Otp.PinGenerator.generate_pin(4)
    {:ok, "0123"}

    iex> SmsUp.Otp.PinGenerator.generate_pin(100)
    {:ok, "0123456789"}

    iex> SmsUp.Otp.PinGenerator.generate_pin(0)
    {:error, "invalid size of 0, please use a positive integer"}

    iex> SmsUp.Otp.PinGenerator.generate_pin(-6)
    {:error, "invalid size of -6, please use a positive integer"}
  """
  @spec generate_pin(integer) :: {:error, String.t()} | {:ok, String.t()}
  def generate_pin(size \\ 6)

  def generate_pin(size) when is_integer(size) and size > 0 do
    pin = 0..9
    |> Enum.take_random(size)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()

    {:ok, pin}
  end

  def generate_pin(size) do
    {:error, "invalid size of #{size}, please use a positive integer"}
  end
end
