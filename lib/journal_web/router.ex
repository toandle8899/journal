defmodule JournalWeb.Router do
  use JournalWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JournalWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JournalWeb do
    pipe_through :browser

    # Point to our custom LiveViews
    live "/sign-in", AuthLive.Index, :index
    live "/register", AuthLive.Register, :register
    sign_out_route AuthController
    auth_routes_for Journal.Accounts.User, to: AuthController, overrides: [
      AshAuthentication.Phoenix.Overrides.Default,
      {AshAuthentication.Phoenix.Overrides.Default, [auth_success_path: "/journals"]}
    ]

    ash_authentication_live_session :authenticated_routes,
      otp_app: :journal,
      on_mount: {AshAuthentication.Phoenix.LiveSession, :live_user_required} do
      live "/journals", JournalLive.Index, :index
      live "/journals/new", JournalLive.Index, :new
      live "/journals/:id/edit", JournalLive.Index, :edit
    end

    get "/", PageController, :redirect_to_signin
  end

  # Define specific auth scope if needed, but auth_routes_for handles it.
  
  # API scope
  # scope "/api", JournalWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:journal, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JournalWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
