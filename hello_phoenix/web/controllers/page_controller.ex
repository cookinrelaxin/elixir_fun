defmodule HelloPhoenix.PageController do
  use HelloPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, :index
  end

  def test(conn, _params) do
    render conn, "test.html"
  end

end
