defmodule StorageAppWeb.Router do
  use StorageAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug StorageAppWeb.Plug.AuthAccessPipeline
  end

  scope "/api", StorageAppWeb do
    pipe_through :api

    scope "/auth" do
      post "/identity/callback", AuthController, :identity_callback
    end

    pipe_through :authenticated

    resources "/users", UserController, except: [:new, :edit]

    resources "/products", ProductController

    resources "/companies", CompanyController

  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: StorageAppWeb.Telemetry
    end
  end
end
