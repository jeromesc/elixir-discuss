defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    # function plugs! (with atoms)
    plug :put_secure_browser_headers
    # module plug
    plug Discuss.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    # get "/", TopicController, :index

    # # Display the form to create a new record
    # get "/topics/new", TopicController, :new
    # # Receive the form to insert the Topic in the Repo
    # post "/topics", TopicController, :create

    # # Display the form to edit the Topic
    # get "/topics/:id/edit", TopicController, :edit
    # # receive the form to update it in the Repo
    # put "/topics/:id/update", TopicController, :update

    # # delete
    # delete "/topics/:id", TopicController, :delete

    # everything / route to the default
    # Topic controller (assuming we have followed our REST convention)
    # REPLACES all of the above
    resources "/topics", TopicController



  end

  # all prefixed with /auth
  scope "/auth", Discuss do
    # pipelines of plugs (for any request we preprocess)
    pipe_through :browser

    # setup auth controller

    # from localhost (I want to authenticate)
    # can be facebook, github, etc. replaced in :provider
    get "/:provider", AuthController, :request

    # Sent from github back to localhost
    get "/:provider/callback", AuthController, :callback

    get "/signout", AuthController, :signout
  end
  

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
