defmodule StorageApp.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :sender_id references(:companies)
      add :receiver_id references(:companies)
      add :operator_id references(:users)
      add :fulfilled :boolean
      timestamps()
    end

  end
end
