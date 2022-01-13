defmodule Fakeblog.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fakeblog.Blog` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Fakeblog.Blog.create_post()

    post
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> Fakeblog.Blog.create_comment()

    comment
  end
end
