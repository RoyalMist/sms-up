defmodule SmsUp.Delivery do
  @moduledoc false
  @callback deliver(String.t(), String.t(), Keyword.t()) ::
              {:error, String.t()}
              | {:ok, %{body: String.t(), to: String.t(), options: Keyword.t()}}
end
