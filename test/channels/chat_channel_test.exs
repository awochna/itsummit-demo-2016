defmodule SummitChat.Channels.ChatChannelTest do
  use SummitChat.ChannelCase
  import SummitChat.TestHelpers

  setup do
    user = insert_user(name: "Anthony")
    token = Phoenix.Token.sign(@endpoint, "user socket", user.id)
    now =
      DateTime.utc_now()
      |> DateTime.to_unix()
    {:ok, socket} = connect(SummitChat.UserSocket, %{"token" => token})
    {:ok, socket: socket, user: user, now: now}
  end

  test "join replies with the messages", %{socket: socket, user: user} do
    for body <- ~w(one two) do
      user
      |> build_assoc(:messages, %{body: body})
      |> Repo.insert!()
    end
    {:ok, reply, _} = subscribe_and_join(socket, "chat:lobby", %{})

    assert %{messages: [%{body: "one"}, %{body: "two"}]} = reply
  end

  test "inserting new messages", %{socket: socket, now: now} do
    {:ok, _, socket} = subscribe_and_join(socket, "chat:lobby", %{})
    ref = push socket, "new_message", %{body: "the body", at: now}
    assert_reply ref, :ok, %{}
    assert_broadcast "new_message", %{}
  end
end
