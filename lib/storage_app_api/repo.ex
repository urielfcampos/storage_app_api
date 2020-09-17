defmodule StorageApp.Repo do
  use Ecto.Repo,
    otp_app: :storage_app_api,
    adapter: Ecto.Adapters.Postgres
end
