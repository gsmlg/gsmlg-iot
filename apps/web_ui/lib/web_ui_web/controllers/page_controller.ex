defmodule WebUiWeb.PageController do
  use WebUiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
