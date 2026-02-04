defmodule Journal.Journals do
  use Ash.Domain,
    otp_app: :journal

  resources do
    resource Journal.Journals.Entry do
      define :create_entry, action: :create
      define :read_entries, action: :read
      define :read_entries_by_date, action: :by_date, args: [:date]
      define :get_entry, action: :read, get_by: [:id]
      define :destroy_entry, action: :destroy
    end
  end
end
