defmodule SummitChat.Repo.Migrations.AddGravatars do
  use Ecto.Migration

  def change do

    alter table(:users) do
      add :gravatar, :string
    end
  end
end
