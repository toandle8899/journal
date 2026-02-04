# Delete existing user and create fresh one
email = "test@journal.com"
password = "password123"

IO.puts("Deleting any existing user with email: #{email}")
require Ash.Query
case Journal.Accounts.User
     |> Ash.Query.filter(email == ^email)
     |> Ash.read_one() do
  {:ok, user} when not is_nil(user) ->
    Ash.destroy!(user)
    IO.puts("✅ Deleted existing user")
  _ ->
    IO.puts("No existing user found")
end

IO.puts("\nCreating new user...")
{:ok, user} = Journal.Accounts.User.register(%{
  email: email,
  password: password,
  password_confirmation: password
})

IO.puts("✅ User created successfully!")
IO.puts("\nCredentials:")
IO.puts("  Email: #{email}")
IO.puts("  Password: #{password}")

IO.puts("\nTesting sign in...")
case Journal.Accounts.User.sign_in(%{email: email, password: password}) do
  {:ok, _signed_in_user} ->
    IO.puts("✅ Sign in works!")
  {:error, error} ->
    IO.puts("❌ Sign in failed")
    IO.inspect(error)
end
