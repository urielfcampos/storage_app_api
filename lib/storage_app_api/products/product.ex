defmodule StorageApp.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "product" do
    field :name, :string
    field :price, :decimal
    field :quantity, :integer
    field :unit, :string
    belongs_to :company, StorageApp.Companies.Company
    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :quantity, :unit])
    |> validate_required([:name, :price, :quantity, :unit])
  end
end
