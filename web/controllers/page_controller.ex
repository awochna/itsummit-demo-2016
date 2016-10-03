defmodule SummitChat.PageController do
  use SummitChat.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
