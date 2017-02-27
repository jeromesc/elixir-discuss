defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  # mix ecto.migrate
  def change do
    create table(:users) do

      add :email, :string
      # facebook, github
      add :provider, :string

      add :token, :string
      
      # add created_at and modified_at fields
      timestamps()
    end
  end
end
