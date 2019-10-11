defmodule Fw.Scene.SysInfo do
  use Scenic.Scene
  alias Scenic.Graph

  import Scenic.Primitives

  @target System.get_env("MIX_TARGET") || "host"

  @system_info """
  Scenic version: #{Scenic.version()}
  Cpus: #{Fw.SysInfo.cpus()}
  """

  @graph Graph.build(font_size: 22, font: :roboto_mono)
         |> group(
           fn g ->
             g
             |> text("System", font_size: 28)
             |> text(@system_info, translate: {20, 30}, font_size: 28)
           end,
           t: {10, 30}
         )
         |> group(
           fn g ->
             g
             |> text("Input Devices")
             |> text("Devices are being loaded...",
               translate: {10, 20},
               font_size: 28,
               id: :devices
             )
           end,
           t: {280, 30},
           id: :device_list
         )
         |> group(
           fn g ->
             g
             |> text("Network", font_size: 28)
             |> text("Network are being loaded...",
               translate: {10, 20},
               font_size: 14,
               id: :netinfo
             )
           end,
           t: {10, 130},
           id: :net_list
         )

  # --------------------------------------------------------
  def init(_, opts) do
    {:ok, info} = Scenic.ViewPort.info(opts[:viewport])

    # styles: #{stringify_map(Map.get(info, :styles, %{a: 1, b: 2}))}
    # transforms: #{stringify_map(Map.get(info, :transforms, %{}))}
    # drivers: #{stringify_map(Map.get(info, :drivers))}

    graph =
      @graph
      |> Graph.modify(:device_list, &update_opts(&1, hidden: @target == "host"))

    unless @target == "host" do
      # subscribe to the simulated temperature sensor
      Process.send_after(self(), :update_devices, 100)
    end
    Process.send_after(self(), :update_netinfo, 100)

    {:ok, graph, push: graph}
  end

  def handle_info(:update_netinfo, graph) do
    Process.send_after(self(), :update_netinfo, 1000)

    # update the graph
    graph = Graph.modify(graph, :netinfo, &text(&1, Fw.SysInfo.netinfo()))

    {:noreply, graph, push: graph}
  end

  unless @target == "host" do
    # --------------------------------------------------------
    # Not a fan of this being polling. Would rather have InputEvent send me
    # an occasional event when something changes.
    def handle_info(:update_devices, graph) do
      Process.send_after(self(), :update_devices, 1000)

      devices =
        InputEvent.enumerate()
        |> Enum.reduce("", fn {_, device}, acc ->
          Enum.join([acc, inspect(device), "\r\n"])
        end)

      # update the graph
      graph = Graph.modify(graph, :devices, &text(&1, devices))

      {:noreply, graph, push: graph}
    end
  end
end
