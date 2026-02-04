defmodule Journal.Accounts.Token do
  use Ash.Resource,
    domain: Journal.Accounts,
    data_layer: AshSqlite.DataLayer,
    extensions: [AshAuthentication.TokenResource] 
  
  sqlite do
    table "tokens"
    repo Journal.Repo
  end
end
