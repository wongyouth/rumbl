defmodule Rumbl.Multimedia do
  @moduledoc """
  The Multimedia context.
  """

  import Ecto.Query, warn: false
  alias Rumbl.Repo

  alias Rumbl.Multimedia.{Video, Category}
  alias Rumbl.Accounts

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos do
    Video
    |> Repo.all()
    |> preload_user()
    |> preload_category()
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id) do
    Video
    |> Repo.get!(id)
    |> preload_user()
    |> preload_category()
  end

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(%Accounts.User{} = user, attrs \\ %{}) do
    %Video{}
    |> Video.changeset(attrs)
    |> put_user(user)
    |> Repo.insert()
  end

  @doc """
  Put user into changeset
  """
  defp put_user(changeset, user) do
    Ecto.Changeset.put_assoc(changeset, :user, user)
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(user, video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%Accounts.User{} = user, %Video{} = video) do
    video
    |> Video.changeset(%{})
    |> put_user(user)
  end

  def list_user_videos(user) do
    Video
    |> user_query_video(user)
    |> Repo.all()
    |> preload_user()
    |> preload_category()
  end

  def get_user_video!(user, id) do
    from(v in Video, where: v.id == ^id)
    |> user_query_video(user)
    |> Repo.one!()
    |> preload_user()
    |> preload_category()
  end

  defp user_query_video(query, %Accounts.User{id: id}) do
    from v in query, where: v.user_id == ^id
  end

  defp preload_user(video_or_videos) do
    Repo.preload(video_or_videos, :user)
  end

  defp preload_category(video_or_videos) do
    Repo.preload(video_or_videos, :category)
  end

  def create_category(name) do
    Repo.get_by(Category, name: name) ||
      Repo.insert!(%Category{name: name})
  end
end
