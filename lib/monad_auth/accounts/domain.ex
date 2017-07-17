defmodule MonadAuth.Accounts.Domain do
  use Ecto.Schema
  import Ecto.Changeset
  alias MonadAuth.Accounts.Domain

  @primary_key false
  schema "accounts_domain" do
    field :name, :string, primary_key: true
    field :user_count, :integer

    # timestamps()
  end

  @doc false
  def changeset(%Domain{} = domain, attrs) do
    domain
    |> cast(attrs, [:name, :user_count])
    |> validate_required([:name])
  end
end
