defmodule SummitChat.Router do
  use SummitChat.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SummitChat.Auth, repo: SummitChat.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SummitChat do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController, only: [:show, :new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SummitChat do
  #   pipe_through :api
  # end
end
