defmodule StorageApp.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do

    belongs_to :sender, StorageApp.Companies.Company
    belongs_to :receiver, StorageApp.Companies.Company
    has_many :products, StorageApp.Products.Product
    belongs_to :operator, StorageApp.Account.User
    field :fulfilled, :boolean
    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [])
    |> validate_required([])
  end
end
