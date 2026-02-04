require Ash.Query

user_email = "dangcaplame@gmail.com"
{:ok, user} = Journal.Accounts.User
                |> Ash.Query.filter(email == ^user_email)
                |> Ash.read_one()

IO.inspect(user, label: "User")

{:ok, entries} = Journal.Journals.Entry
                 |> Ash.read(actor: user)

IO.inspect(entries, label: "Entries")
