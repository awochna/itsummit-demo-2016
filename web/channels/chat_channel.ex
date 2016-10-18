defmodule SummitChat.ChatChannel do
  use SummitChat.Web, :channel
  alias SummitChat.MessageView

  def join("chat:lobby", params, socket) do
    last_seen_id = params["last_seen_id"] || 0

    messages = Repo.all(
      from m in SummitChat.Message,
      where: m.id > ^last_seen_id,
      order_by: [asc: m.at, asc: m.id],
      limit: 200,
      preload: [:user]
      )

    resp = %{messages: Phoenix.View.render_many(messages, MessageView,
      "message.json")}
    {:ok, resp, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in(event, params, socket) do
    user = Repo.get(SummitChat.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  def handle_in("new_message", params, user, socket) do
    changeset =
      user
      |> build_assoc(:messages)
      |> SummitChat.Message.changeset(params)

    case Repo.insert(changeset) do
      {:ok, msg} ->
        broadcast_message(socket, msg)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  defp broadcast_message(socket, message) do
    message = Repo.preload(message, :user)
    rendered_msg = Phoenix.View.render(MessageView, "message.json", %{
      message: message
    })
    broadcast! socket, "new_message", rendered_msg
  end
end
