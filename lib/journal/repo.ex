defmodule Journal.Repo do
  use AshSqlite.Repo,
    otp_app: :journal,
    adapter: Ecto.Adapters.SQLite3
end
