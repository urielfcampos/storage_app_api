# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :storage_app_api,
  namespace: StorageApp,
  ecto_repos: [StorageApp.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :storage_app_api, StorageAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WUqJo5bR8uH2MZlm74uCm4bvMc/hHtLX12GLAzQnI+8M3p4YsLtyZiD0kdkwa0Cm",
  render_errors: [view: StorageAppWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: StorageApp.PubSub,
  live_view: [signing_salt: "aJgx+y3w"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
