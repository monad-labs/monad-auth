defmodule MonadAuth.Repo.Migrations.CreateMonadAuth.Accounts.Domain do
  use Ecto.Migration

  def change do
    create table(:accounts_domain) do
      add :name, :string

      timestamps()
    end

  end
end
