defmodule FakeblogWeb.InlineCommentComponent do
  use FakeblogWeb, :live_component

  alias Fakeblog.Blog

  require Logger

  def mount(socket) do
    Logger.info("mounted")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
    <h2>livecomponent comment <%= @idx %></h2>
    <%= hidden_input @comment, :id, id: "hidden-comment-#{@idx}" %>
    <%= label @comment, :body, "comment body" %>
    <%= text_input @comment, :body, "phx-debounce": "blur", id: "hidden-body-#{@idx}" %>
    <%= error_tag @comment, :body %>
    debug: <%= inspect @comment %>
    <br />
    errors: <%= inspect Map.get(@comment, :errors) %>
    </div>
    """
  end
end
