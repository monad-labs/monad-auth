defmodule MonadAuth.Repo.Migrations.CreateMonadAuth.Accounts.Domain do
  use Ecto.Migration

  def change do
    create table(:accounts_domain) do
      add :name, :string
      add :user_count, :integer

      timestamps()
    end

  end
end
