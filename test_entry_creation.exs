# Manual test to verify entry creation works

# 1. Create a test user
email = "testuser#{:rand.uniform(10000)}@example.com"
password = "testpassword123"

IO.puts("Creating test user: #{email}")
{:ok, user} = Journal.Accounts.User.register(%{
  email: email,
  password: password,
  password_confirmation: password
})
IO.inspect(user, label: "Created user")

# 2. Create an entry for this user
IO.puts("\nCreating journal entry...")
{:ok, entry} = Journal.Journals.create_entry(%{
  title: "Test Entry",
  content: "This is a test entry to verify creation works"
}, actor: user)
IO.inspect(entry, label: "Created entry")

# 3. Verify we can read the entry back
IO.puts("\nReading entries for user...")
{:ok, entries} = Journal.Journals.read_entries(actor: user)
IO.inspect(entries, label: "All entries")

# 4. Verify the entry appears in the list
if Enum.any?(entries, fn e -> e.id == entry.id end) do
  IO.puts("\n✅ SUCCESS: Entry was created and can be read back!")
else
  IO.puts("\n❌ FAILURE: Entry was not found in the list")
end
