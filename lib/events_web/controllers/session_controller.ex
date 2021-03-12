defmodule EventsWeb.SessionController do
  use EventsWeb, :controller

  def times(email, i, c) do
    cond do
      i == length(Events.Users.list_users())  ->
        c
      true ->
        cond do
          email == Enum.at(Events.Users.list_users(), i).email ->
            if (c > 0) do
              Events.Users.delete_user(Events.Users.get_user(Enum.at(Events.Users.list_users(), i).id))
              times(email, i, c)
            else
              times(email, 1 + i, 1 + c)
            end
          true ->
            times(email, 1 + i, c)
        end
    end
  end

#  BASED ON NAT TUCKS LECTURE CODE:

  def create(conn, %{"name" => name}) do
    if times(name, 0, 0) < 2 do # verifying that two users don't share an email
        user = Events.Users.get_user_by_email(name) # email
        if user do # and that user does not appear twice
          conn
          |> put_session(:user_id, user.id)
          |> put_flash(:info, "Welcome back #{user.name}")
          |> redirect(to: Routes.page_path(conn, :index))
        else
          conn
          |> delete_session(:user_id)
          |> put_flash(:error, "Login failed")
          |> redirect(to: Routes.page_path(conn, :index))
        end
    else
      conn
        |> delete_session(:user_id)
        |> put_flash(:error, "Yo is that two users?! you may want to make sure there aren't two users registered with the same email, if so, delete one of them")
        |> redirect(to: Routes.user_path(conn, :index))
    end
  end


  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end

# END ATTRIBUTION
