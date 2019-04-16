defmodule Rumbl.TestHelpers do

  alias Rumbl.{
    Accounts,
    Multimedia
  }

  def user_fixture(attrs \\ %{}) do
    username = "user#{System.unique_integer([:positive])}"

    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "user name",
        username: username,
        credential: %{
          email: "#{username}@qq.com",
          password: "newpass"
        }
      })
      |> Accounts.register_user()

    user
  end

  def video_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{
      description: "some description", title: "some title", url: "some url",
      category: %{name: "Comedy"}
    })
    {:ok, video} = Multimedia.create_video(user, attrs)
    video
  end

end
