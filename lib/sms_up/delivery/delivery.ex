defmodule SmsUp.Delivery do
  @moduledoc false
  @callback deliver(String.t(), String.t(), Keyword.t()) ::
              {:ok, %{body: String.t(), to: String.t(), options: Keyword.t()}}
              | {:error, String.t()}
end
