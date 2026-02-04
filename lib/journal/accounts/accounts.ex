defmodule Journal.Accounts do
  use Ash.Domain,
    otp_app: :journal

  resources do
    resource Journal.Accounts.User
    resource Journal.Accounts.Token
  end
end
