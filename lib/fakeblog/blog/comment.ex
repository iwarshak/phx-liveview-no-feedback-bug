defmodule Fakeblog.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fakeblog.Blog.Post

  schema "comments" do
    field :body, :string
    field :post_id, :id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :post_id])
    |> validate_required([:body, :post_id])
  end
end
