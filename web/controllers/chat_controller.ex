defmodule SummitChat.ChatController do
  use SummitChat.Web, :controller
  plug :authenticate_user when action in [:index]

  def index(conn, _) do
    render conn, "index.html"
  end
end
