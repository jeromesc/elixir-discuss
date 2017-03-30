defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  
  alias Discuss.Topic # instead of writing %Discuss.Topic, only write %Topic

  # execute before any handler
  plug Discuss.Plugs.RequireAuth 
    when action in [:new, :create, :edit, :update, :delete]

  # Check that the current User owns the Topic
  # this is very specific to this controller though,
  # we'll create a function plug
  plug :check_topic_owner when action in [:ipdate, :edit, :delete]

  # Present the list of Topics
  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def show(conn, %{"id" => topic_id} = _params) do
    # get! will redirect the user to 404 if not found
    topic = Repo.get!(Topic, topic_id)
    render conn, "show.html", topic: topic
  end

  # /topics/new
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  # POST /topics
  def create(conn, %{"topic" => topic} = _params) do
    
    # We need to associate the User with the Topic
    changeset = conn.assigns.user
      |> build_assoc(:topics)
      # changeset = Topic.changeset(%Topic{}, topic)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} -> 
        conn 
        # imported from :controller
        # flash: shown only one time!
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> 
        render conn, "new.html", changeset: changeset
    end
  end

  # GET /topics/:id/edit
  # we receiving an id from the params
  # edit/2 = Showing a form
  def edit(conn, %{"id" => topic_id} = _params) do
    # changeset + topic struct + form template

    # topic struct
    topic = Repo.get(Topic, topic_id)

    # changeset
    changeset = Topic.changeset(topic)

    # form template
    render conn, "edit.html", changeset: changeset, topic: topic

  end

  # PUT /topics/:id/update
  # Update the information about the topic
  # in the database
  def update(conn, %{"id" => topic_id, "topic" => topic} = _params) do

    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  
  end

  # Remember : in the route file (we added ressources "Topic"
  # bu default, the signature of this operation now must conform
  # to receiveive an "id" field (not topic_id) 
  def delete(conn, %{"id" => topic_id}) do
    # delete bang (delete!) raises an error if something
    # went wrong : user will receive a 40x or 50x
    # could be appropriate for the delete function
    Repo.get!(Topic, topic_id) |> Repo.delete!
    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect to: topic_path(conn, :index)
  end

  # This is a function plug (instead of module plug)
  # BTW _params is not the same structure 
  # as in controller's _params
  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
        conn
    else
      conn
        |> put_flash(:error, "You cannot edit that")
        |> redirect(to: topic_path(conn, :index))
        |> halt()
    end
  end


end