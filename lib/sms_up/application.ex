defmodule SmsUp.Application do
  @moduledoc false

  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      # {SmsUp.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: SmsUp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
