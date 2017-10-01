defmodule Goto.Support do
  @moduledoc """
  The Support context.
  """

  import Ecto.Query, warn: false
  alias Goto.Repo

  alias Goto.Support.{Comment, Issue}

  @doc """
  Returns the list of issues.

  ## Examples

      iex> list_issues()
      [%Issue{}, ...]

  """
  def list_issues do
    Repo.all(Issue)
  end

  @doc """
  Gets a single issue.

  Raises `Ecto.NoResultsError` if the Issue does not exist.

  ## Examples

      iex> get_issue!(123)
      %Issue{}

      iex> get_issue!(456)
      ** (Ecto.NoResultsError)

  """
  def get_issue!(id), do: Repo.get!(Issue, id)

  @doc """
  Creates a issue.

  ## Examples

      iex> create_issue(user, %{field: value})
      {:ok, %Issue{}}

      iex> create_issue(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_issue(user, attrs \\ %{}) do
    Goto.Support.IssueCreator.create_issue(user, attrs)
  end

  @doc """
  Updates a issue.

  ## Examples

      iex> update_issue(issue, %{field: new_value})
      {:ok, %Issue{}}

      iex> update_issue(issue, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_issue(%Issue{} = issue, attrs) do
    issue
    |> Issue.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Issue.

  ## Examples

      iex> delete_issue(issue)
      {:ok, %Issue{}}

      iex> delete_issue(issue)
      {:error, %Ecto.Changeset{}}

  """
  def delete_issue(%Issue{} = issue) do
    Repo.delete(issue)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking issue changes.

  ## Examples

      iex> change_issue(issue)
      %Ecto.Changeset{source: %Issue{}}

  """
  def change_issue(%Issue{} = issue) do
    Issue.changeset(issue, %{})
  end

  @doc """
  Returns the list of comments for a given issue.

  ## Examples

      iex> list_comments(issue)
      [%Comment{}, ...]

  """
  def list_comments(issue) do
    issue
    |> list_comments_query()
    |> Repo.all()
  end

  defp list_comments_query(issue) do
    from c in Comment,
      where: c.issue_id == ^issue.id,
      join: u in assoc(c, :user),
      order_by: c.inserted_at,
      preload: [user: u]
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(issue, user, %{field: value})
      {:ok, %Comment{}}

      iex> create_comment(issue, user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(issue, user, attrs \\ %{}) do
    issue
    |> Ecto.build_assoc(:comments, %{user_id: user.id})
    |> Ecto.Changeset.cast(attrs, [:body])
    |> Ecto.Changeset.validate_required([:body])
    |> Repo.insert()
    |> case do
      {:ok, comment} ->
        {:ok, %{comment | user: user}}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
