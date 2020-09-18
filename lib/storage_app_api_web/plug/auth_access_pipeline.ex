defmodule StorageAppWeb.Plug.AuthAccessPipeline do
  @moduledoc """
  Auth Pipeline plug
  """
  use Guardian.Plug.Pipeline, otp_app: :storage_app_api

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, ensure: true
end
