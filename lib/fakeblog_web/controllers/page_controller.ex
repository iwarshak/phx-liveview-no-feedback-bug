defmodule FakeblogWeb.PageController do
  use FakeblogWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
