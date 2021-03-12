defmodule EventsWeb.PageController do
  use EventsWeb, :controller

  alias Events.Posts
  # alias Events.Invitees

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end
end
