defmodule Fakeblog.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fakeblog.Blog.Comment

  schema "posts" do
    field :title, :string
    has_many :comments, Comment, on_replace: :delete, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> cast_assoc(:comments)
  end
end
