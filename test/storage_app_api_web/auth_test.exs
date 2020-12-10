defmodule StorageAppWeb.AuthTest do
  use StorageAppWeb.ConnCase

  describe "authorization" do
    test "request to authorized endpoint", %{conn: conn} do
       conn = get(conn, Routes.user_path(conn, :index))
       assert "unauthenticated" == json_response(conn, 401)["message"]
    end
  end
end
