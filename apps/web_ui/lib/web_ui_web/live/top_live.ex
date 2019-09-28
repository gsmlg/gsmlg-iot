defmodule WebUiWeb.TopLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <pre>
      <%= @top %>
    </pre>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, put_top(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_top(socket)}
  end

  defp put_top(socket) do
    case :os.type() do
      {:unix, :darwin} ->
        {top, 0} = System.cmd("ps", [])
        assign(socket, top: top)
      {:unix, :linux} ->
        {top, 0} = System.cmd("ps", [])
        assign(socket, top: top)
    end
  end
end
