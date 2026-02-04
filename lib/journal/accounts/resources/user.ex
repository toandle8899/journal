defmodule Journal.Accounts.User do
  use Ash.Resource,
    domain: Journal.Accounts,
    data_layer: AshSqlite.DataLayer,
    extensions: [AshAuthentication]

  authentication do
    strategies do
      password :password do
        identity_field :email
      end
    end

    tokens do
      enabled? true
      token_resource Journal.Accounts.Token
      signing_secret fn _, _ -> 
        # In production this should be in config/runtime.exs
        Application.fetch_env(:journal, :token_signing_secret)
      end
      require_token_presence_for_authentication? true
    end
  end

  actions do
    defaults [:read]
  end

  code_interface do
    domain Journal.Accounts
    define :register, action: :register_with_password
    define :sign_in, action: :sign_in_with_password
  end

  sqlite do
    table "users"
    repo Journal.Repo
  end

  attributes do
    uuid_primary_key :id
    
    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  
    timestamps()
  end

  identities do
    identity :unique_email, [:email]
  end
end
