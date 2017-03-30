# to create a migration file use : mix ecto.gen.migration add_comments
# to update the database use : mix ecto.migrate
# then create the model file (/model)
defmodule Discuss.Repo.Migrations.AddComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :user_id, references(:users)
      add :topic_id, references(:topics)

      timestamps()
    end
  end
end
