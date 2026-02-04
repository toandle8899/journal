email = "dangcaplame@gmail.com"
password = "123456"

IO.puts("Attempting to register user: #{email}")

try do
  case Journal.Accounts.User.register(%{email: email, password: password, password_confirmation: password}) do
    {:ok, user} -> 
      IO.inspect(user, label: "Registration Successful")
    {:error, error} -> 
      IO.inspect(error, label: "Registration Failed")
  end
rescue
  e -> IO.inspect(e, label: "Exception during registration")
end
