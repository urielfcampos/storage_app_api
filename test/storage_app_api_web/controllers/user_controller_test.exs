defmodule StorageAppWeb.UserControllerTest do
  use StorageAppWeb.ConnCase

  alias StorageApp.Account
  alias StorageApp.Account.User

  @create_attrs %{
    is_active: true,
    password: "some password",
    permissions: %{guest: true, admin: false}
  }
  @update_attrs %{
    is_active: false,
    password: "some updated password",
    permissions: %{guest: true, admin: false}
  }
  @invalid_attrs %{email: nil, is_active: nil, password: nil}

  def fixture(:user) do
    user_params = @create_attrs
    user_params = Map.put(user_params, :email, StorageApp.Util.Random.generate_number(14) |> Integer.to_string())
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
    test "lists all users", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :index))
      visualized_user = %{"email" => user.email, "id" => user.id, "is_active" => user.is_active}
      assert json_response(conn, 200)["data"] == [visualized_user]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      user_params = @create_attrs
      user_params = Map.put(user_params, :email, StorageApp.Util.Random.generate_number(14) |> Integer.to_string())
      conn = post(conn, Routes.user_path(conn, :create), user: user_params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => email,
               "is_active" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      user_params = @update_attrs
      user_params = Map.put(user_params, :email, StorageApp.Util.Random.generate_number(14) |> Integer.to_string())
      conn = put(conn, Routes.user_path(conn, :update, user), user: user_params)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => email,
               "is_active" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
