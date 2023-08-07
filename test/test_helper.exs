defmodule TestCluster do
  def start_slaves(number) do
    :ok = :net_kernel.monitor_nodes(true)
    _ = :os.cmd(~c"epmd -daemon")
    Node.start(:master@localhost, :shortnames)

    Enum.each(1..number, fn index ->
      :slave.start_link(:localhost, ~c"slave_#{index}")
    end)

    [node() | Node.list()]
  end

  def disconnect(list) do
    Enum.map(list, &Node.disconnect(&1))
  end
end

ExUnit.start()
