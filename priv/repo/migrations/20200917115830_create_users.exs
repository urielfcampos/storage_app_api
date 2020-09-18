defmodule StorageApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :is_active, :boolean, default: false, null: false
      add :password_hash, :string
      add :permissions, :map
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
