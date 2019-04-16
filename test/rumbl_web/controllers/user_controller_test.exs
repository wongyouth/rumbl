defmodule RumblWeb.UserControllerTest do
  use RumblWeb.ConnCase

  @create_attrs %{name: "some name", username: "username",
    credential: %{email: "user@qq.com", password: "newpass"}}
  @update_attrs %{name: "some updated name", username: "updated username"}
  @invalid_attrs %{name: nil, username: nil}

  describe "login in user" do
    setup %{conn: conn, login_as: username} do
      user = user_fixture(username: username)
      conn = assign(conn, :current_user, user)

      {:ok, conn: conn, user: user}
    end

    @tag login_as: "max"
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end

    @tag login_as: "max"
    test "deletes chosen user", %{conn: conn, user: user} do
      conn1 = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(conn1) == Routes.user_path(conn1, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end

    @tag login_as: "max"
    test "create user and redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    @tag login_as: "max"
    test "do not create user and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end


    @tag login_as: "max"
    test "update user and redirects when data is valid", %{conn: conn, user: user} do
      conn1 = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn1) == Routes.user_path(conn1, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "some updated name"
    end

    @tag login_as: "max"
    test "do not update user and renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end

  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end



  defp create_user(_) do
    user = user_fixture()
    {:ok, user: user}
  end
end
