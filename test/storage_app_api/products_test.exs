defmodule StorageApp.ProductsTest do
  use StorageApp.DataCase

  alias StorageApp.Products

  describe "products" do
    alias StorageApp.Products.Product

    @valid_attrs %{name: "some name", price: "120.5", quantity: 42, unit: "some unit"}
    @update_attrs %{name: "some updated name", price: "456.7", quantity: 43, unit: "some updated unit"}
    @invalid_attrs %{name: nil, price: nil, quantity: nil, unit: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.name == "some name"
      assert product.price == Decimal.new("120.5")
      assert product.quantity == 42
      assert product.unit == "some unit"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
      assert product.name == "some updated name"
      assert product.price == Decimal.new("456.7")
      assert product.quantity == 43
      assert product.unit == "some updated unit"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
