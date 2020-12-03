defmodule SmsUp.Delivery do
  @moduledoc false
  @callback deliver(String.t(), String.t(), Keyword.t()) ::
              {:ok, %{to: String.t(), body: String.t(), options: Keyword.t()}}
              | {:error, String.t()}
end
