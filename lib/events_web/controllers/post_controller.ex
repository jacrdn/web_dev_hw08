defmodule EventsWeb.PostController do
  use EventsWeb, :controller

  alias Events.Posts
  alias Events.Posts.Post
  alias Events.Photos

  alias EventsWeb.Plugs
  plug Plugs.RequireUser when action not in [
    :index, :show, :photo]
  plug :fetch_post when action in [
    :show, :photo, :edit, :update, :delete]
  plug :require_owner when action in [
    :edit, :update, :delete]

  def fetch_post(conn, _args) do
    id = conn.params["id"]
    post = Posts.get_post!(id)
    assign(conn, :post, post)
  end

  def require_owner(conn, _args) do
    # Precondition: We have these in conn
    user = conn.assigns[:current_user]
    post = conn.assigns[:post]

    if user.id == post.user_id do
      conn
    else
      conn
      |> put_flash(:error, "That isn't yours.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    post_params = post_params
    |> Map.put("user_id", conn.assigns[:current_user].id)
    case Posts.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = conn.assigns[:post]
    |> Posts.load_comments()
    |> Posts.load_invitees()
    |> Posts.load_responses()
    comm = %Events.Comments.Comment{
      post_id: post.id,
      user_id: current_user_id(conn),
    }
    invi = %Events.Invitees.Invitee{
      post_id: post.id,
      email: "",
    }
    res = %Events.Responses.Response{
      post_id: post.id,
      user_id: current_user_id(conn),
    }
    new_comment = Events.Comments.change_comment(comm)
    new_invitee = Events.Invitees.change_invitee(invi)
    new_response = Events.Responses.change_response(res)
    render(conn, "show.html",
      post: post, new_comment: new_comment, new_invitee: new_invitee, new_response: new_response)
  end


  def edit(conn, %{"id" => id}) do
    post = conn.assigns[:post]
    changeset = Posts.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end


  def update(conn, %{"id" => id, "post" => post_params}) do
    post = conn.assigns[:post]
    up = post_params["photo"]

    post_params = if up do
      # FIXME: deref old photo
      {:ok, hash} = Photos.save_photo(up.filename, up.path)
      Map.put(post_params, "photo_hash", hash)
    else
      post_params
    end

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = conn.assigns[:post]
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
