defmodule JournalWeb.AuthController do
  use JournalWeb, :controller
  use AshAuthentication.Phoenix.Controller
  
  def sign_out(conn, _params) do
    return_to = get_session(conn, :return_to) || ~p"/journals"
    conn
    |> clear_session(:journal)
    |> redirect(to: return_to)
  end
end
