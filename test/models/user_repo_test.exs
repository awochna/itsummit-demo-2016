defmodule SummitChat.UserRepoTest do
  use SummitChat.ModelCase
  alias SummitChat.User

  @valid_attrs %{email: "some content", name: "some content", password: "some content", username: "some content"}

  test "converts unique_constraint on username to error" do
    insert_user(username: "anthony")
    attrs = Map.put(@valid_attrs, :username, "anthony")
    changeset = User.changeset(%User{}, attrs)

    assert {:error, changeset} = Repo.insert(changeset)
    assert username: {"has already been taken"} in changeset.errors
  end

  test "converts unique_constraint on email to error" do
    insert_user(email: "example@example.com")
    attrs = Map.put(@valid_attrs, :email, "example@example.com")
    changeset = User.changeset(%User{}, attrs)

    assert {:error, changeset} = Repo.insert(changeset)
    assert email: {"has already been taken"} in changeset.errors
  end
end
