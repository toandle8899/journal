defmodule Journal.Journals.Entry do
  use Ash.Resource,
    domain: Journal.Journals,
    data_layer: AshSqlite.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  sqlite do
    table "entries"
    repo Journal.Repo
  end

  relationships do
    belongs_to :user, Journal.Accounts.User do
      allow_nil? false
    end
  end

  actions do
    defaults [:read, :destroy, update: :*]

    create :create do
      accept [:title, :content, :date]
      change relate_actor(:user)
    end

    read :by_date do
      argument :date, :date, allow_nil?: false
      filter expr(date == ^arg(:date))
    end
  end

  policies do
    # Anyone can read any entry (Sharing feature)
    policy action_type(:read) do
      authorize_if always()
    end

    # Only authenticated users can create
    policy action(:create) do
      authorize_if actor_present()
    end

    # Only owner can update/destroy
    policy action_type(:update) do
      authorize_if relates_to_actor_via(:user)
    end

    policy action_type(:destroy) do
      authorize_if relates_to_actor_via(:user)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
      public? true
    end

    attribute :content, :string do
      allow_nil? false
      public? true
      constraints [max_length: 50000] # Large enough for journal entries
    end

    attribute :date, :date do
      allow_nil? false
      public? true
      default &Date.utc_today/0
    end

    timestamps()
  end
end
