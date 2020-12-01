defmodule SmsUp.Pin.Db.Clustering do
  @moduledoc false
  use GenServer
  require Logger

  def start_link(_init_args) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_args) do
    nodes = [node() | Node.list()]
    Amnesia.start()
    :net_kernel.monitor_nodes(true)
    {:ok, nodes}
  end

  def handle_info({:nodeup, node}, nodes) do
    nodes = [node | nodes]
    Amnesia.Schema.create(nodes)
    :mnesia.change_config(:extra_db_nodes, [node])
    {:noreply, nodes}
  end

  def handle_info({:nodedown, node}, nodes) do
    nodes = nodes |> Enum.filter(&(&1 !== node))
    {:noreply, nodes}
  end
end
