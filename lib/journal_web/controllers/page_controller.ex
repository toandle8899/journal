defmodule JournalWeb.PageController do
  use JournalWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
