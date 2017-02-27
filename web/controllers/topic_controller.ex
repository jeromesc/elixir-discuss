defmodule Discuss.TopicController do
    use Discuss.Web, :controller
    alias Discuss.Topic # instead of writing %Discuss.Topic, only write %Topic



    # Present the list of Topics
    def index(conn, _params) do
      topics = Repo.all(Topic)
      render conn, "index.html", topics: topics
    end

    # /topics/new
    def new(conn, _params) do
      changeset = Topic.changeset(%Topic{}, %{})

      render conn, "new.html", changeset: changeset
    end

    # POST /topics
    def create(conn, %{"topic" => topic} = _params) do
      changeset = Topic.changeset(%Topic{}, topic)

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


end