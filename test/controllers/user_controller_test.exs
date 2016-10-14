defmodule SummitChat.UserControllerTest do
  use SummitChat.ConnCase

  alias SummitChat.User

  @valid_attrs %{email: "example@example.com", username: "user1", name: "User 1", password: "supersecret"}
  @invalid_attrs %{}

  test "renders form for registering", %{conn: conn} do
    conn = get(conn, user_path(conn, :new))
    assert html_response(conn, 200) =~ "Sign up"
  end

  test "creates a new user when data is valid", %{conn: conn} do
    conn = post(conn, user_path(conn, :create), user: @valid_attrs)
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by(User, %{email: @valid_attrs.email})
  end

  test "fails to create user and renders errors when invalid", %{conn: conn} do
    conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
    assert html_response(conn, 200) =~ "Sign up"
  end
end
