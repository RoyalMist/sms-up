defmodule SmsUp.Delivery.SmsUpDeliveryTest do
  use ExUnit.Case
  alias SmsUp.Delivery.SmsUpDelivery

  describe "Should construct url with the mandatory fields and otpions" do
    test "Should construct url with mandatory params" do
      assert "https://api.smsup.ch/send?text=hello&to=+41765556677" ==
               SmsUpDelivery.make_uri("+41765556677", "hello")
    end

    test "Should construct url with mandatory params and encode it properly for special chars" do
      assert "https://api.smsup.ch/send?text=Hola%20ni%C3%B1os&to=+41765556677" ==
               SmsUpDelivery.make_uri("+41765556677", "Hola niños")
    end

    test "Should construct url with mandatory params and pushtype param" do
      assert "https://api.smsup.ch/send?text=Hello&to=+41765556677&pushtype=alert" ==
               SmsUpDelivery.make_uri("+41765556677", "Hello", pushtype: "alert")
    end

    test "Should construct url with mandatory params and all optional params" do
      assert "https://api.smsup.ch/send?text=Hello&to=+41765556677&pushtype=alert&delay=2020-06-07%2012:50:00&sender=Me&gsmsmsid=id" ==
               SmsUpDelivery.make_uri("+41765556677", "Hello",
                 pushtype: "alert",
                 delay: "2020-06-07 12:50:00",
                 sender: "Me",
                 gsmsmsid: "id"
               )
    end

    test "Should not include not supported optional param" do
      assert "https://api.smsup.ch/send?text=Hello&to=+41765556677&pushtype=alert" ==
               SmsUpDelivery.make_uri("+41765556677", "Hello", pushtype: "alert", one: "two")
    end
  end
end
