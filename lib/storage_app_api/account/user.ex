defmodule StorageApp.Account.User do
  @moduledoc """
    Module for user schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :is_active, :boolean, default: false
    field :password, :string, virtual: true
    field :password_hash, :string
    field :permissions, :map

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_active, :password, :permissions])
    |> validate_required([:email, :is_active, :password, :permissions])
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp hash_password(changeset) do
    changeset
  end

end
