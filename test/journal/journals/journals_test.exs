defmodule Journal.JournalsTest do
  use Journal.DataCase, async: true
  alias Journal.Journals


  describe "entries" do
    setup do
      user = Journal.Accounts.User.register!(%{
        email: "user@example.com",
        password: "password123",
        password_confirmation: "password123"
      })
      {:ok, user: user}
    end

    test "create/1 allows creating a new entry", %{user: user} do
      assert {:ok, entry} = Journals.create_entry(%{title: "First Day", content: "Hello World"}, actor: user)
      assert entry.title == "First Day"
      assert entry.content == "Hello World"
      assert entry.date == Date.utc_today()
      assert entry.user_id == user.id
    end

    test "read_entries/0 returns all entries", %{user: user} do
      Journals.create_entry!(%{title: "E1", content: "C1"}, actor: user)
      Journals.create_entry!(%{title: "E2", content: "C2"}, actor: user)

      # Sharing check: should see all entries
      assert {:ok, entries} = Journals.read_entries(actor: user)
      assert length(entries) == 2
    end

    test "read_entries_by_date/1 filters by date", %{user: user} do
      today = Date.utc_today()
      yesterday = Date.add(today, -1)

      Journals.create_entry!(%{title: "Today", content: "X", date: today}, actor: user)
      Journals.create_entry!(%{title: "Yesterday", content: "Y", date: yesterday}, actor: user)

      assert {:ok, [entry]} = Journals.read_entries_by_date(today, actor: user)
      assert entry.title == "Today"

      assert {:ok, [entry_old]} = Journals.read_entries_by_date(yesterday, actor: user)
      assert entry_old.title == "Yesterday"
    end
  end
end
