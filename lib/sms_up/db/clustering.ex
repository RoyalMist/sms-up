defmodule SmsUp.Db.Clustering do
  @moduledoc false
  use GenServer
  require Logger

  def start_link(_init_args) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_args) do
    Logger.info("Starting Mnesia Cluster Manager")
    :net_kernel.monitor_nodes(true)
    Memento.start()
    {:ok, nil}
  end

  def handle_info({:nodeup, node}, _) do
    Logger.info("Add #{node} to the cluster")
    :mnesia.change_config(:extra_db_nodes, [node])
    {:noreply, nil}
  end

  def handle_info({:nodedown, node}, _) do
    Logger.info("#{node} left the cluster")
    {:noreply, nil}
  end
end
