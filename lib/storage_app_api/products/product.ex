defmodule StorageApp.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :name, :string
    field :price, :decimal
    field :quantity, :integer
    field :unit, :string
    many_to_many :companies, StorageApp.Companies.Company, join_through: "company_products"
    many_to_many :orders, StorageApp.Orders.Order, join_through: "order_products"

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :quantity, :unit])
    |> validate_required([:name, :price, :quantity, :unit])
  end
end
