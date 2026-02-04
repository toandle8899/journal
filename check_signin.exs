email = "ducktoan0808@gmail.com"
password = "12345678"  # Try the longer password

IO.puts("Checking if user exists...")
require Ash.Query
{:ok, user} = Journal.Accounts.User
              |> Ash.Query.filter(email == ^email)
              |> Ash.read_one()

if user do
  IO.puts("✅ User found: #{user.email}")
  
  IO.puts("\nAttempting sign in...")
  case Journal.Accounts.User.sign_in(%{email: email, password: password}) do
    {:ok, signed_in_user} ->
      IO.puts("✅ Sign in successful!")
      IO.inspect(signed_in_user, label: "Signed in user")
    {:error, error} ->
      IO.puts("❌ Sign in failed")
      IO.inspect(error, label: "Error")
  end
else
  IO.puts("❌ User not found")
  IO.puts("\nTrying to register user...")
  case Journal.Accounts.User.register(%{
    email: email,
    password: password,
    password_confirmation: password
  }) do
    {:ok, new_user} ->
      IO.puts("✅ User registered successfully")
      IO.inspect(new_user, label: "New user")
    {:error, error} ->
      IO.puts("❌ Registration failed")
      IO.inspect(error, label: "Error")
  end
end
