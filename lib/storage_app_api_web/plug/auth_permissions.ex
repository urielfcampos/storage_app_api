defmodule StorageAppWeb.Plug.Permissions do
  @moduledoc """
  A plug module for validating permission, not finished and not needed at the moment
  Finish the module when permissions are needed
  """
  import Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{private: %{:guardian_default_resource => user}} = conn, _default) do
    validate_permissions(user.permissions, conn.request_path)
    conn
  end
  def call(conn, default) do
    conn
  end
  defp validate_permissions(permissions, request_path) do
    permissions
  end
end
