defmodule SummitChat.Message do
  use SummitChat.Web, :model

  schema "messages" do
    field :body, :string
    field :at, :integer
    belongs_to :user, SummitChat.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :at])
    |> validate_required([:body, :at])
  end
end
