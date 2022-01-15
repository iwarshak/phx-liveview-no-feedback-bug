defmodule FakeblogWeb.PostLive.Index do
  use FakeblogWeb, :live_view

  alias Fakeblog.Blog
  alias Fakeblog.Blog.{Post, Comment}
  alias Fakeblog.Repo
  require Logger

  def func_component(assigns) do
    ~H"""
    <h2>func component comment <%= @idx  %></h2>
    <%= hidden_input @comment, :id, id: "func-component-id-#{@idx}" %>
    <%= label @comment, :body, "comment body" %>
    <%= text_input @comment, :body, "phx-debounce": "blur", id: "func-component-body-#{@idx}" %>
    <%= error_tag @comment, :body %>
    debug: <%= inspect @comment %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :posts, list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("add-comment", %{}, socket) do
    Logger.info("adding comment to changeset")
    changeset = socket.assigns.changeset

    comments = Ecto.Changeset.get_field(changeset, :comments)
    comments = comments ++ [
      %Comment{post_id: socket.assigns.post.id}
    ]

    changeset = changeset
    |> Ecto.Changeset.put_change(:comments, comments)

    socket = socket
    |> assign(:changeset, changeset)
    |> push_event("trigger-validate", %{})

    {:noreply, socket}
  end

  @impl true
  # If I handle the dummy_input event separately, and do NOT add an action to the changeset, the LiveComponent form input works
  # def handle_event("validate", params = %{"_target" => ["post", "dummy_input"], "post" => post_params}, socket) do
  #   Logger.warn("got a dummy")
  #   changeset = socket.assigns.post
  #   |> Post.changeset(post_params)
  #   # |> Map.put(:action, :validate)

  #   socket = socket
  #   |> assign(:changeset, changeset)
  #   {:noreply, socket}
  # end

  @impl true
  def handle_event("validate", %{"post" => post_params} = params, socket) do
    Logger.info("validating post #{inspect post_params} params: #{inspect params} ")
    changeset = socket.assigns.post
    |> Post.changeset(post_params)
    |> Map.put(:action, :validate)

    socket = socket
    |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    post = Blog.get_post!(id)
    |> Repo.preload(:comments)
    changeset = Post.changeset(post, %{})
    socket
    |> assign(:page_title, "Edit PostY")
    |> assign(:post, post)
    |> assign(:changeset, changeset)
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    Logger.info("saving post #{inspect post_params}")
    post = case socket.assigns.post do
      nil -> %Post{}
      post = %Post{} -> post
    end

    res = post
    |> Post.changeset(post_params)
    |> Repo.update()

    socket = case res do
      {:ok, post} ->
        socket
        |> assign(:post, post)
        |> assign(:changeset, Post.changeset(post, %{}))
      {:error, err} ->
        socket
        |> assign(:changeset, err)
    end

    Logger.info("save status #{inspect post}")

    socket = socket
    # |> put_flash(:info, "Post updated successfully")
    {:noreply, socket}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Blog.get_post!(id)
    {:ok, _} = Blog.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts())}
  end

  defp list_posts do
    Blog.list_posts()
  end
end
