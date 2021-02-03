defmodule SmsUp.SenderTest do
  use ExUnit.Case
  doctest SmsUp.Sender
  alias SmsUp.Sender

  describe "Should assert that phone numbers are porperly formated" do
    test "Should accept a properly formatted international number and return the message text within a ok tuple" do
      assert {:ok, %{to: "+41765557788", body: "message", options: []}} ==
               Sender.send_sms("+41765557788", "message", [])
    end

    test "Should accept a properly formatted international number and return the message text within a ok tuple and accept options" do
      assert {:ok, %{to: "+41765557788", body: "message", options: [pushtype: "alert"]}} ==
               Sender.send_sms("+41765557788", "message", pushtype: "alert")
    end

    test "Should refuse a malformated international number" do
      assert {:error, "0705557788 is not a valid number"} ==
               Sender.send_sms("0705557788", "message", [])
    end
  end

  describe "Should format the given number to international format and delegate to send/2 if successfull" do
    test "Should accept a properly formatted international and forward" do
      assert {:ok, %{to: "+41765557788", body: "message", options: []}} ==
               Sender.send_sms("+41765557788", "CH", "message", [])
    end

    test "Should accept a properly formatted national and forward" do
      assert {:ok, %{to: "+41765557788", body: "message", options: []}} ==
               Sender.send_sms("0765557788", "CH", "message", [])
    end

    test "Should accept a properly formatted national and forward without leading 0" do
      assert {:ok, %{to: "+41765557788", body: "message", options: []}} ==
               Sender.send_sms("765557788", "CH", "message", [])
    end

    test "Should refuse a malformated international number" do
      assert {:error, "+41557788 is not a valid number"} ==
               Sender.send_sms("557788", "CH", "message", [])
    end

    test "Should refuse a invalid country code" do
      assert {:error, "Invalid country calling code"} ==
               Sender.send_sms("0765557788", "ZZ", "message", [])
    end

    test "Should refuse a invalid number" do
      assert {:error, "The string supplied did not seem to be a phone number"} ==
               Sender.send_sms("Hello", "CH", "message", [])
    end
  end
end
