defmodule SummitChat.User do
  use SummitChat.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :gravatar, :string

    timestamps()
  end

  @doc """
  Builds a changeset for editing.

  Does not include password.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :username, :email], [])
    |> validate_required([:username, :email])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_gravatar()
  end

  @doc """
  Builds a changeset for registrations, includes passwords.
  """
  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:password], [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  defp put_gravatar(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} ->
        hash =
          :crypto.hash(:md5, email)
          |> Base.encode16
          |> String.downcase
        put_change(changeset, :gravatar, hash)
      _ -> 
        changeset
    end
  end
end
