defmodule WebUiWeb.NetworkLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <h2>Network</h2>
    <section class="row">
    <%= for net <- @networks do %>
    <article class="column">
    <h3><%= Map.get(net, :ifname, "---") %></h3>
    <ul>
    <%= for {k,v} <- net do %>
    <li>
    <b><%= k %></b>:
    <%= if is_map(v) do %>
    <ul>
    <%= for {kk,vv} <- v do %>
    <li>
    <b><%= kk %></b>: <%= vv %>
    </li>
    <% end %>
    </ul>    
    <% else %>
    <%= v %>
    <% end %>
    </li>
    <% end %>
    </ul>
    </article>
    <% end %>
    </section>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(5000, self(), :tick)

    {:ok, put_network(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_network(socket)}
  end

  defp put_network(socket) do
    networks = Nerves.NetworkInterface.interfaces |> Enum.map(fn(ifname) ->
      status = case Nerves.Network.status(ifname) do
                 status when is_map(status) -> status
                 _ -> %{}
               end
      stats = case Nerves.NetworkInterface.status(ifname) do
                {:ok, stats} -> stats
                _ -> %{}
              end
      Map.merge(status, stats)
    end)
    assign(socket, networks: networks)
  end
end
