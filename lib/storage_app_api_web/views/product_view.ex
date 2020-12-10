defmodule StorageAppWeb.ProductView do
  use StorageAppWeb, :view
  alias StorageAppWeb.ProductView

  def render("index.json", %{product: product}) do
    %{data: render_many(product, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: product.quantity,
      unit: product.unit
    }
  end
end
