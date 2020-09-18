defmodule StorageAppWeb.AuthController do
  use StorageAppWeb, :controller

  alias StorageApp.Account

  plug Ueberauth

  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    email = auth.uid
    password = auth.credentials.other.password
    handle_user_conn(Account.get_user_by_email_and_password(email, password), conn)
  end

  defp handle_user_conn(user, conn) do
    case user do
      {:ok, user} ->
        {:ok, jwt, _full_claims} =
          StorageApp.Guardian.encode_and_sign(user, %{})

        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> json(%{data: %{token: jwt}})

      # Handle our own error to keep it generic
      {:error, _reason} ->
        conn
        |> put_status(401)
        |> json(%{message: "user not found"})
    end
  end
end
