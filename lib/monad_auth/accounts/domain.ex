defmodule MonadAuth.Accounts.Domain do
  use Ecto.Schema
  import Ecto.Changeset
  alias MonadAuth.Accounts.Domain


  schema "accounts_domain" do
    field :name, :string
    field :user_count, :integer

    timestamps()
  end

  @doc false
  def changeset(%Domain{} = domain, attrs) do
    domain
    |> cast(attrs, [:name, :user_count])
    |> validate_required([:name])
  end
end
