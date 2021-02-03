defmodule SmsUp.Pin.GeneratorTest do
  use ExUnit.Case
  doctest SmsUp.Pin.Generator
  alias SmsUp.Pin.Generator

  describe "generate_pin" do
    setup do
      [size | _] = 1..10 |> Enum.take_random(1)
      %{size: size}
    end

    test "should return a random string of 6 digits in case no size is provided" do
      {:ok, attempt_one} = Generator.generate_pin()
      assert String.length(attempt_one) == 6
      {:ok, attempt_two} = Generator.generate_pin()
      refute attempt_one == attempt_two
    end

    test "should return a random string of n digits in case size is provided", %{size: size} do
      {:ok, attempt_one} = Generator.generate_pin(size)
      assert String.length(attempt_one) == size
      {:ok, attempt_two} = Generator.generate_pin(size)
      refute attempt_one == attempt_two
    end

    test "should return a random string of 10 digits in case size of more than 10 is provided" do
      {:ok, attempt_one} = Generator.generate_pin(100)
      assert String.length(attempt_one) == 10
      {:ok, attempt_two} = Generator.generate_pin(100)
      refute attempt_one == attempt_two
    end

    test "should return an error in case size of 0 is provided" do
      assert {:error, "invalid size of 0, please use a positive integer"} ==
               Generator.generate_pin(0)
    end

    test "should return an error in case negative size of is provided" do
      assert {:error, "invalid size of -12, please use a positive integer"} ==
               Generator.generate_pin(-12)
    end

    test "should return an error in case any other type is provided for size" do
      assert {:error, "invalid size of hello, please use a positive integer"} ==
               Generator.generate_pin("hello")
    end
  end
end
