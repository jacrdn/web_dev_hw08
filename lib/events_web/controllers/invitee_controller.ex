defmodule EventsWeb.InviteeController do
  use EventsWeb, :controller

  alias Events.Invitees
  alias Events.Invitees.Invitee

  def index(conn, _params) do
    invitees = Invitees.list_invitees()
    render(conn, "index.html", invitees: invitees)
  end

  def new(conn, _params) do
    changeset = Invitees.change_invitee(%Invitee{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invitee" => invitee_params}) do
    invitee_params = invitee_params
    |> Map.put("user_id", current_user_id(conn))
    case Invitees.create_invitee(invitee_params) do
      {:ok, invitee} ->
        conn
        |> put_flash(:info, "invitee created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, invitee.post_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    invitee = Invitees.get_invitee!(id)
    render(conn, "show.html", invitee: invitee)
  end

  def edit(conn, %{"id" => id}) do
    invitee = Invitees.get_invitee!(id)
    changeset = Invitees.change_invitee(invitee)
    render(conn, "edit.html", invitee: invitee, changeset: changeset)
  end

  def update(conn, %{"id" => id, "invitee" => invitee_params}) do
    invitee = Invitees.get_invitee!(id)

    case Invitees.update_invitee(invitee, invitee_params) do
      {:ok, invitee} ->
        conn
        |> put_flash(:info, "Invitee updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, invitee.post_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", invitee: invitee, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    invitee = Invitees.get_invitee!(id)
    {:ok, _invitee} = Invitees.delete_invitee(invitee)

    conn
    |> put_flash(:info, "Invitee deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
