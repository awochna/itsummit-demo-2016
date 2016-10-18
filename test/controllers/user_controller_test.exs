defmodule SummitChat.UserControllerTest do
  use SummitChat.ConnCase

  alias SummitChat.User

  @valid_attrs %{email: "example@example.com", username: "user1", name: "User 1", password: "supersecret"}
  @invalid_attrs %{}

  defp user_count(query), do: Repo.one(from u in query, select: count(u.id))

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(username: username)
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "renders form for registering", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "Sign up"
  end

  test "creates a new user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == chat_path(conn, :index)
    assert Repo.get_by(User, %{email: @valid_attrs.email})
  end

  test "fails to create user and renders errors when invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Sign up"
  end

  test "fails with non-unique username", %{conn: conn} do
    username = %{username: @valid_attrs.username}
    _ = insert_user(username)
    before_count = user_count(User)
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert html_response(conn, 200) =~ "Sign up"
    assert Repo.get_by(User, username).username == @valid_attrs.username
    assert user_count(User) == before_count
  end

  test "fails with non-unique email address", %{conn: conn} do
    email = %{email: @valid_attrs.email}
    _ = insert_user(email)
    before_count = user_count(User)
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert html_response(conn, 200) =~ "Sign up"
    assert Repo.get_by(User, email).email == @valid_attrs.email
    assert user_count(User) == before_count
  end

  @tag login_as: "alex"
  test "shows requested user", %{conn: conn} do
    user = insert_user()
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ user.username
    assert html_response(conn, 200) =~ user.name
    refute html_response(conn, 200) =~ user.email
    refute html_response(conn, 200) =~ user.password
    refute html_response(conn, 200) =~ user.password_hash
  end

  @tag login_as: "alex"
  test "gives 404 for non-existent user", %{conn: conn} do
    assert_error_sent :not_found, fn ->
      get conn, user_path(conn, :show, 9999)
    end
  end
end
