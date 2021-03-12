defmodule Events.Responses.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :response, :string
    belongs_to :post, Events.Posts.Post
    belongs_to :user, Events.Users.User

    timestamps()
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:response, :post_id, :user_id])
    |> validate_required([:response, :post_id, :user_id])
  end
end
