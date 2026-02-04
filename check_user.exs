require Ash.Query

email = "dangcaplame@gmail.com"
user_result = Journal.Accounts.User
              |> Ash.Query.filter(email == ^email)
              |> Ash.read_one()

case user_result do
  {:ok, user} -> IO.inspect(user, label: "User found")
  {:error, error} -> IO.inspect(error, label: "Error finding user")
end
