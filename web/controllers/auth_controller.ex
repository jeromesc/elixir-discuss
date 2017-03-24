defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  alias Discuss.User
  # plug: ??
  plug Ueberauth

  # Ueberauth assumes the callback function
  # def callback(conn, params) do
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token,
                    email: auth.info.email,
                    provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    sign_in(conn, changeset)
  end

def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: topic_path(conn, :index))
  end

  def signout(conn, _params) do
    conn
    # better than put_session(:user_id, nil)
    # because it clears everything
    |> configure_session(drop: true)
    |> put_flash(:info, "Signed out")
    |> redirect(to: topic_path(conn, :index))
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        # Update session cookie
        conn
        |> put_flash(:info, "Welcome back!")
        # Add a cookie with the  user id value (encrypted)
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end



  # defp : private function (only inside the function)
  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> 
        Repo.insert(changeset)
      user -> 
        # we return the same tuple as well as when use Repo.insert/1
        {:ok, user}
    end
  end

end