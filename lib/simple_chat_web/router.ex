defmodule SimpleChatWeb.Router do
  use SimpleChatWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SimpleChatWeb do
    pipe_through :api
  end
end
