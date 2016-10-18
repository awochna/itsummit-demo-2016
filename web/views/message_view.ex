defmodule SummitChat.MessageView do
  use SummitChat.Web, :view

  def render("message.json", %{message: msg}) do
    %{
      id: msg.id,
      body: msg.body,
      at: msg.at,
      user: render_one(msg.user, SummitChat.UserView, "user.json")
    }
  end
end
