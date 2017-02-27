#  Retrieve the user_id from the session
#  Goal: have access to the User model in any Connector object
defmodule Discuss.Plugs.SetUser do
  # working with connection object
  import Plug.Conn # assign

  import Phoenix.Controller # get_session

  # grab the user id out of the conn object
  alias Discuss.Repo
  alias Discuss.User

  # must have 2 functions : init (one time only) 
  # and call (each time) functions

  # no initial setup needed
  # i.e.: pull out multiple records from the DB
  def init(_params) do
  end

  # (called each time)
  # _params is not the same object in the controller functions
  # it is the thing transfered from the init/1 function
  def call(conn, _params) do
    # from sign_in, we put_session(:user_id, user.id)
    # here we want to get it
    user_id = get_session(conn, :user_id)

    # condition statement (looks like case, but not)
    cond do
      # got user_id
      user = user_id && Repo.get(User, user_id) ->
        # assign : function to modify the struct
        assign(conn, :user, user)
        # if we want to access 
        # conn.assigns.user => user struct
        # careful : assigns with an s
      # we don't have the user_id
      true ->
        # we did not find any user
        assign(conn, :user, nil)
    end
  end

end