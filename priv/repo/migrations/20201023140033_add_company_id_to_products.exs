defmodule StorageApp.Repo.Migrations.AddCompanyIdToProducts do
  use Ecto.Migration

  def change do
    alter table(:product) do
      add :company_id, :binary_id, [references(:companies)]
    end
  end
end
