defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn # Halt()
  import Phoenix.Controller # put_flash
  
  alias Discuss.Router.Helpers # Helpers.topic_path

  def init(_params) do
  end

  # _params is not the same structure as in controllers
  def call(conn, params) do
    if conn.assigns[:user] do
      # returns the conn object (success)
      conn
    else
      # not logged in
      conn
      |> put_flash(:error, "You must be logged in.")
      # Helpers : it's like using the 'use' keyword
      # at the top of the module
      |> redirect(to: Helpers.topic_path(conn, :index))
      # plugs : everything is done, stop the pipeline
      # and get back to the user
      |> halt()
    end
  end

end