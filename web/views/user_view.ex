defmodule SummitChat.UserView do
  use SummitChat.Web, :view

  def render("user.json", %{user: user}) do
    %{username: user.username, gravatar: user.gravatar}
  end
end
