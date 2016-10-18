defmodule SummitChat.TestHelpers do
  alias SummitChat.Repo

  def insert_user(attrs \\ %{}) do
    num = Base.encode16(:crypto.strong_rand_bytes(8))
    changes = Dict.merge(%{
      name: "Some User",
      username: "user#{num}",
      email: "user#{num}@example.com",
      password: "supersecret",
    }, attrs)

    %SummitChat.User{}
    |> SummitChat.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_message(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:messages, attrs)
    |> Repo.insert!()
  end
end
