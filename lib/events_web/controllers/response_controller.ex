defmodule EventsWeb.ResponseController do
  use EventsWeb, :controller

  alias Events.Responses
  alias Events.Responses.Response

  def index(conn, _params) do
    responses = Responses.list_responses()
    render(conn, "index.html", responses: responses)
  end

  def new(conn, _params) do
    changeset = Responses.change_response(%Response{})
    render(conn, "new.html", changeset: changeset)
  end

  # def times(uid, i, c) do
  #   cond do
  #     i == length(Events.Responses.list_users())  ->
  #       c
  #     true ->
  #       cond do
  #         uid == Enum.at(Events.Responses.list_users(), i).email ->
  #           if (c > 0) do
  #             Events.Responses.delete_user(Events.Responses.get_user(Enum.at(Events.Responses.list_users(), i).id))
  #             times(uid, i, c)
  #           else
  #             times(uid, 1 + i, 1 + c)
  #           end
  #         true ->
  #           times(uid, 1 + i, c)
  #       end
  #   end
  # end

  def create(conn, %{"response" => response_params}) do
    response_params = response_params
    |> Map.put("user_id", current_user_id(conn))
    case Responses.create_response(response_params) do
      {:ok, response} ->
        conn
        |> put_flash(:info, "response created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, response.post_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    response = Responses.get_response!(id)
    render(conn, "show.html", response: response)
  end

  def edit(conn, %{"id" => id}) do
    response = Responses.get_response!(id)
    changeset = Responses.change_response(response)
    render(conn, "edit.html", response: response, changeset: changeset)
  end

  def update(conn, %{"id" => id, "response" => response_params}) do
    response = Responses.get_response!(id)

    case Responses.update_response(response, response_params) do
      {:ok, response} ->
        conn
        |> put_flash(:info, "Response updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, response.post_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", response: response, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    response = Responses.get_response!(id)
    {:ok, _response} = Responses.delete_response(response)

    conn
    |> put_flash(:info, "Response deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
