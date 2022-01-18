defmodule SmsUp.Delivery.LoggerDeliveryTest do
  use ExUnit.Case
  doctest SmsUp.Delivery.LoggerDelivery
  alias SmsUp.Delivery.LoggerDelivery
  import ExUnit.CaptureLog
  require Logger

  describe "Should log sms to the console if nor errors are forced" do
    test "Should log the message without options" do
      {result, log} =
        with_log(fn ->
          LoggerDelivery.deliver("+41765556677", "Hello")
        end)

      assert result == {:ok, %{to: "+41765556677", body: "Hello", options: []}}
      assert log =~ "[info]"
      assert log =~ "SMS"
      assert log =~ "To : +41765556677"
      assert log =~ "Body: Hello"
    end

    test "Should log the message with options" do
      {result, log} =
        with_log(fn ->
          LoggerDelivery.deliver("+41765556677", "Hello", who: "John Doe")
        end)

      assert result == {:ok, %{to: "+41765556677", body: "Hello", options: [who: "John Doe"]}}
      assert log =~ "[info]"
      assert log =~ "SMS"
      assert log =~ "To : +41765556677"
      assert log =~ "Body: Hello"
      assert log =~ "who: John Doe"
    end

    test "Should not log the message if option force_error is present" do
      {result, log} =
        with_log(fn ->
          LoggerDelivery.deliver("+41765556677", "Hello", force_error: "Boom!", who: "John Doe")
        end)

      assert result == {:error, "Boom!"}
      assert log == ""
    end
  end
end
