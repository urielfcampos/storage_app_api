defmodule StorageAppWeb.ProductControllerTest do
  use StorageAppWeb.ConnCase

  alias StorageApp.Products
  alias StorageApp.Account
  alias StorageApp.Products.Product

  @create_attrs %{
    name: "some name",
    price: "120.5",
    quantity: 42,
    unit: "some unit"
  }
  @update_attrs %{
    name: "some updated name",
    price: "456.7",
    quantity: 43,
    unit: "some updated unit"
  }
  @invalid_attrs %{name: nil, price: nil, quantity: nil, unit: nil}

  def fixture(:product) do
    {:ok, company} =
      %{name: "Test company"}
      |> StorageApp.Companies.create_company()

    {:ok, product} = Products.create_product(company.id, @create_attrs)

    product
  end

  def fixture(:user) do
    user_params = %{
      email: "some email",
      is_active: true,
      password: "some password",
      permissions: %{guest: true, admin: false}
    }

    {:ok, user} = Account.create_user(user_params)
    user
  end

  setup %{conn: conn} do
    user = fixture(:user)

    {:ok, jwt, _claims} = StorageApp.Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all product", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      {:ok, company} =
        %{name: "Test company"}
        |> StorageApp.Companies.create_company()

      conn =
        post(conn, Routes.product_path(conn, :create),
          product: @create_attrs,
          company_id: company.id
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.product_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "price" => "120.5",
               "quantity" => 42,
               "unit" => "some unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      {:ok, company} =
        %{name: "Test company"}
        |> StorageApp.Companies.create_company()

      conn =
        post(conn, Routes.product_path(conn, :create),
          product: @invalid_attrs,
          company_id: company.id
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.product_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "price" => "456.7",
               "quantity" => 43,
               "unit" => "some updated unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, Routes.product_path(conn, :delete, product))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.product_path(conn, :show, product))
      end
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    %{product: product}
  end
end
