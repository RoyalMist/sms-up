defmodule SmsUp.Numbers.PhoneValidatorTest do
  use ExUnit.Case
  doctest SmsUp.Numbers.PhoneValidator
  alias SmsUp.Numbers.PhoneValidator

  describe "Should validate international numbers that are already formated" do
    test "Should return true for a valid format" do
      assert PhoneValidator.is_valid_number?("+41765006080")
    end

    test "Should return false for an invalid format 1" do
      refute PhoneValidator.is_valid_number?("41705006080")
    end

    test "Should return false for an invalid format 2" do
      refute PhoneValidator.is_valid_number?("0705006080")
    end

    test "Should return false for an invalid format 3" do
      refute PhoneValidator.is_valid_number?("0705080")
    end

    test "Should return false for an invalid format 4" do
      refute PhoneValidator.is_valid_number?("hello")
    end

    test "Should return false for an invalid format 5" do
      refute PhoneValidator.is_valid_number?("")
    end
  end

  describe "Should format the given number to international format regarding the given country code" do
    test "Should format a valid number with valid country code (CH)" do
      assert {:ok, "+41765557788"} == PhoneValidator.format("0765557788", "CH")
    end

    test "Should format a valid number with valid country code (FR)" do
      assert {:ok, "+33630772288"} == PhoneValidator.format("0630772288", "FR")
    end

    test "Should format a valid number missing the 0 prefix" do
      assert {:ok, "+41765557788"} == PhoneValidator.format("765557788", "CH")
    end

    test "Should left a valid international formated number unchanged" do
      assert {:ok, "+41765557788"} == PhoneValidator.format("+41765557788", "CH")
    end

    test "Should return an error in case of not valid country code" do
      assert {:error, "Invalid country calling code"} == PhoneValidator.format("0765557788", "ZZ")
    end

    test "Should return an error in case of not valid phone number" do
      assert {:error, "The string supplied did not seem to be a phone number"} ==
               PhoneValidator.format("Hello", "FR")
    end
  end
end
