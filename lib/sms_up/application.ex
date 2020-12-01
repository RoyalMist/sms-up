defmodule SmsUp.Application do
  @moduledoc false

  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      SmsUp.Pin.Db.Clustering,
      {SmsUp.Pin.Store, [pin_validity: get_pin_validity(), pin_size: get_pin_size()]}
    ]

    opts = [strategy: :one_for_one, name: SmsUp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_pin_validity do
    Application.get_env(:sms_up, :pin_validity, 10)
  end

  defp get_pin_size do
    Application.get_env(:sms_up, :pin_size, 6)
  end
end
