defmodule Discuss.Comment do
  use Discuss.Web, :model

  # refers to 'create table(:comments)' in the migration file
  schema "comments" do
    field :content, :string

    # for those relations, we need to also
    # modify the User and Topic models to
    # create the relation
    belongs_to :user, Discuss.User
    belongs_to :topic, Discuss.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct 
    |> cast(params, [:content])
    |> validate_required([:content])
  end


end