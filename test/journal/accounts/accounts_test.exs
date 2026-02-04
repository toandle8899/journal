defmodule Journal.AccountsTest do
  use Journal.DataCase, async: true
  alias Journal.Accounts


  describe "users" do
    test "register_user_with_password/1 registers a new user" do
      assert {:ok, user} = Accounts.User.register(%{
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      })

      assert to_string(user.email) == "test@example.com"
      assert user.hashed_password
    end

    test "sign_in_with_password/1 authenticates valid credentials" do
      Accounts.User.register!(%{
        email: "auth@example.com",
        password: "password123",
        password_confirmation: "password123"
      })

      assert {:ok, user} = Accounts.User.sign_in(%{
        email: "auth@example.com", 
        password: "password123"
      })
      assert to_string(user.email) == "auth@example.com"
    end

    test "sign_in_with_password/1 rejects invalid credentials" do
      Accounts.User.register!(%{
        email: "wrong@example.com",
        password: "password123",
        password_confirmation: "password123"
      })

      assert {:error, _} = Accounts.User.sign_in(%{
        email: "wrong@example.com", 
        password: "wrongpassword"
      })
    end
  end
end
