defmodule JournalWeb.PageController do
  use JournalWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def redirect_to_signin(conn, _params) do
    redirect(conn, to: ~p"/sign-in")
  end
end
