defmodule StorageAppWeb.AuthControllerTest do

  use StorageAppWeb.ConnCase


 describe "login" do
    test "post request with an existing user", %{conn: conn} do
      {:ok, user} = StorageApp.Account.create_user(%{email: "user1@email.com", password: "qwerty", permissions: %{guest: true, admin: false}})
      conn = post(conn, Routes.auth_path(conn, :identity_callback), user: %{email: user.email, password: user.password})
      assert %{"token" => token} = json_response(conn, 200)["data"]
    end
    test "post request with an unexisting user", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :identity_callback), user: %{email: "doesntexist@email.com", password: "qwerty"})
      assert "user not found" = json_response(conn, 401)["message"]
    end
 end

end
