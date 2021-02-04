defmodule SmsUp.Pin.StoreTest do
  use ExUnit.Case, async: true
  alias SmsUp.Pin.Store

  describe "This module should store generated one time password during a certain amount of time a be resilient to restarts" do
    test "should store a pin with the given user id" do
      pin = Store.store(123)
      assert {:ok, true} == Store.validate(123, pin)
    end

    test "should store an pin with the given user email" do
      pin = Store.store("user@email.ch")
      assert {:ok, true} == Store.validate("user@email.ch", pin)
    end

    test "should store an pin and refute the pin if not correct" do
      assert _ = Store.store("user@email.ch")
      assert {:ok, false} == Store.validate("user@email.ch", "123456")
    end

    test "should erase an pin and refute following requests after a success" do
      pin = Store.store("user@email.ch")
      assert {:ok, true} == Store.validate("user@email.ch", pin)
      assert {:ok, false} == Store.validate("user@email.ch", pin)
    end
  end
end
