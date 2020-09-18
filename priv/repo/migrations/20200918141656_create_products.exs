defmodule StorageApp.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :price, :decimal
      add :quantity, :integer
      add :unit, :string

      timestamps()
    end

  end
end
