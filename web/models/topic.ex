defmodule Discuss.Topic do
  use Discuss.Web, :model 
  # :model -> automatically creates a struct with the same name
  # i.e. : Topic

  # Map to migration
  # Add validation

  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.User
  end


  # struct represents a record to-be in the database 
  # params contains the properties to update the struct with
  # Note : default values in elixir are set using \\
  # in this case, we're passing params, if nil, it will
  # be set as empty map
  def changeset(struct, params \\ %{}) do
    struct 
    # produces a changeset: update statements to DB
    |> cast(params, [:title])
    |> validate_required([:title])
    # returns a changeset: how we want to update the DB
  end

end
