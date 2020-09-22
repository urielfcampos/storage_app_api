defmodule StorageApp.Repo.Migrations.AddJoinTableProductCompany do
  use Ecto.Migration

  def change do
      create table(:company_products, primary_key: false) do
        add :product_id, references(:products)
        add :company_id, references(:companies)
      end
  end
end
