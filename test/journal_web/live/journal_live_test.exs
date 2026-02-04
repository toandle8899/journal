defmodule JournalWeb.JournalLiveTest do
  use JournalWeb.ConnCase
  import Phoenix.LiveViewTest

  setup do
    # Create a test user
    {:ok, user} = Journal.Accounts.User.register(%{
      email: "test@example.com",
      password: "testpassword123",
      password_confirmation: "testpassword123"
    })
    
    %{user: user}
  end

  describe "Journal Index" do
    test "creates new entry and displays it immediately", %{conn: conn, user: user} do
      # Sign in the user by setting session
      conn = Plug.Test.init_test_session(conn, %{
        "context" => nil,
        "tenant" => nil
      })
      
      # Mount the LiveView
      {:ok, index_live, _html} = live(conn, ~p"/journals")
      
      # Click new entry button
      assert index_live |> element("a[href='/journals/new']") |> render_click()
      
      # Fill in the form
      assert index_live
             |> form("#entry-form", %{
               "title" => "Test Entry",
               "content" => "This is a test entry content"
             })
             |> render_submit()
      
      # Verify the entry appears in the list
      html = render(index_live)
      assert html =~ "Test Entry"
      assert html =~ "This is a test entry content"
    end
  end
end
