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
end
