defmodule Discuss.User do
  use Discuss.Web, :model 

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    # One to many
    has_many :topics, Discuss.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct 
    # produces a changeset: update statements to DB
    |> cast(params, [:email, :provider, :token])

    |> validate_required([:email, :provider, :token])

    # returns a changeset: how we want to update the DB
  end

end