defmodule RumblWeb.SessionController do
  use RumblWeb, :controller

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User
  alias RumblWeb.Auth

  def new(conn, _) do
    changeset = Accounts.change_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => params}) do
    %{"email" => email, "password" => password} = params
    case Auth.login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back #{conn.assigns.current_user.name}")
        |> redirect(to: Routes.user_path(conn, :index))
      {:error, :unauthorized, conn} ->
        conn
        |> put_flash(:error, "Password is wrong")
        |> render("new.html", changeset: Accounts.change_registration(%User{}, params))
      _ ->
        conn
        |> put_flash(:error, "User not found")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout()
    |> put_flash(:info, "You've signed out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
