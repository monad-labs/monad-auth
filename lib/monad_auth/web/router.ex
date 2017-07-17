defmodule MonadAuth.Web.Router do
  use MonadAuth.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MonadAuth.Web do
    pipe_through :api

    resources "/domains", DomainController
  end
end
