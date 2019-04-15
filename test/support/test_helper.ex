defmodule Rumbl.TestHelpers do

  alias Rumbl.{
    Accounts,
    Multimedia
  }

  @user_attrs %{name: "some name", username: "username",
    credential: %{email: "user@qq.com", password: "newpass"}}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_attrs)
      |> Accounts.register_user()

    user
  end

  @video_attrs %{description: "some description", title: "some title", url: "some url"}

  def video_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs = Enum.into(attrs, @video_attrs)
    {:ok, video} = Multimedia.create_video(user, attrs)
    video
  end
end
