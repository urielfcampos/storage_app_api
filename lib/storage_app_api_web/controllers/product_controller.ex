defmodule StorageAppWeb.ProductController do
  use StorageAppWeb, :controller

  alias StorageApp.Products
  alias StorageApp.Products.Product

  action_fallback StorageAppWeb.FallbackController

  def index(conn, _params) do
    product = Products.list_product()
    render(conn, "index.json", product: product)
  end

  def create(conn, %{"product" => product_params, "company_id" => company_id}) do
    with {:ok, %Product{} = product} <- Products.create_product(company_id, product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.product_path(conn, :show, product))
      |> render("show.json", product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Products.get_product!(id)

    with {:ok, %Product{} = product} <- Products.update_product(product, product_params) do
      render(conn, "show.json", product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Products.get_product!(id)

    with {:ok, %Product{}} <- Products.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end
end
