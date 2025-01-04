defmodule SmsUp.Pin.Generator do
  @moduledoc """
    This module deals with generating random pin codes.
  """

  @doc """
    Generate a random pin number of the given length (min: 1, max: 10).

    Returns a pin of the given length as a string.

  ## Examples (:rand.seed is used here for doctest)

      iex> :rand.seed(:exsss, {10, 20, 30})
      iex> SmsUp.Pin.Generator.generate_pin()
      {:ok, "278950"}

      iex> :rand.seed(:exsss, {10, 20, 30})
      iex> SmsUp.Pin.Generator.generate_pin(4)
      {:ok, "4819"}

      iex> :rand.seed(:exsss, {10, 20, 30})
      iex> SmsUp.Pin.Generator.generate_pin(100)
      {:ok, "8317504629"}

      iex> SmsUp.Pin.Generator.generate_pin(0)
      {:error, "invalid size of 0, please use a positive integer"}

      iex> SmsUp.Pin.Generator.generate_pin(-6)
      {:error, "invalid size of -6, please use a positive integer"}
  """
  @spec generate_pin(integer) :: {:error, String.t()} | {:ok, String.t()}
  def generate_pin(size \\ 6)

  def generate_pin(size) when is_integer(size) and size > 0 do
    pin =
      0..9
      |> Enum.take_random(size)
      |> Enum.map_join(&Integer.to_string/1)

    {:ok, pin}
  end

  def generate_pin(size) do
    {:error, "invalid size of #{size}, please use a positive integer"}
  end
end
