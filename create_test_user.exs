# Create a test user with known credentials
email = "demo@journal.com"
password = "demo12345678"

IO.puts("Creating demo user...")
IO.puts("  Email: #{email}")
IO.puts("  Password: #{password}")

case Journal.Accounts.User.register(%{
  email: email,
  password: password,
  password_confirmation: password
}) do
  {:ok, user} ->
    IO.puts("\n✅ User created successfully!")
    IO.inspect(user.email, label: "Email")
    
    IO.puts("\nTesting sign in...")
    case Journal.Accounts.User.sign_in(%{email: email, password: password}) do
      {:ok, _signed_in_user} ->
        IO.puts("✅ Sign in works!")
        IO.puts("\n🎉 You can now sign in with:")
        IO.puts("   Email: #{email}")
        IO.puts("   Password: #{password}")
      {:error, error} ->
        IO.puts("❌ Sign in failed")
        IO.inspect(error)
    end
    
  {:error, error} ->
    IO.puts("❌ User creation failed (might already exist)")
    IO.inspect(error, label: "Error")
    
    IO.puts("\nTrying to sign in with existing user...")
    case Journal.Accounts.User.sign_in(%{email: email, password: password}) do
      {:ok, _signed_in_user} ->
        IO.puts("✅ Sign in works with existing user!")
        IO.puts("\n🎉 You can sign in with:")
        IO.puts("   Email: #{email}")
        IO.puts("   Password: #{password}")
      {:error, signin_error} ->
        IO.puts("❌ Sign in also failed")
        IO.puts("The user might exist with a different password")
        IO.inspect(signin_error)
    end
end
