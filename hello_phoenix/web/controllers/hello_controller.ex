defmodule HelloPhoenix.HelloController do
  use HelloPhoenix.Web, :controller

  def index(conn, _params) do
    conn
    |> put_layout("admin.html")
    |> assign(:message, "Hello")
    |> assign(:name, "world")
    |> render("index.html")
  end

  def show(conn, %{"messenger" => messenger}) do
    render conn, "show.html", messenger: messenger
  end

end
