defmodule SmsUp.Numbers.PhoneValidator do
  @moduledoc """
  This module provides function to validate phone number formats.
  """

  @doc """
  Check if the number seems to be valid format wise.

  Returns true or false.

  ## Examples

      iex> SmsUp.Numbers.PhoneValidator.is_valid_number?("+41765556677")
      true

      iex> SmsUp.Numbers.PhoneValidator.is_valid_number?("0765556677")
      false

      iex> SmsUp.Numbers.PhoneValidator.is_valid_number?("555")
      false

      iex> SmsUp.Numbers.PhoneValidator.is_valid_number?("hello")
      false
  """
  @spec is_valid_number?(String.t()) :: true | false
  def is_valid_number?(number) when is_binary(number) do
    case ExPhoneNumber.parse(number, nil) do
      {:ok, number} -> ExPhoneNumber.is_valid_number?(number)
      {:error, _error} -> false
    end
  end

  @doc """
  Format the given number to international format.

  Returns a ok tupple with the formated number or an erro tupple and the reason.

  ## Examples

      iex> SmsUp.Numbers.PhoneValidator.format("+41765556677", "CH")
      {:ok, "+41765556677"}

      iex> SmsUp.Numbers.PhoneValidator.format("0765556677", "CH")
      {:ok, "+41765556677"}

      iex> SmsUp.Numbers.PhoneValidator.format("765556677", "CH")
      {:ok, "+41765556677"}

      iex> SmsUp.Numbers.PhoneValidator.format("0630772288", "FR")
      {:ok, "+33630772288"}

      iex> SmsUp.Numbers.PhoneValidator.format("0630772288", "ZZ")
      {:error, "Invalid country calling code"}

      iex> SmsUp.Numbers.PhoneValidator.format("Hello", "FR")
      {:error, "The string supplied did not seem to be a phone number"}
  """
  @spec format(String.t(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def format(number, country_code) when is_binary(number) and is_binary(country_code) do
    case ExPhoneNumber.parse(number, country_code) do
      {:ok, phone_number} -> {:ok, ExPhoneNumber.format(phone_number, :e164)}
      error -> error
    end
  end
end
