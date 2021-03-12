defmodule Events.Invitees.Invitee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invitees" do
    field :email, :string

    belongs_to :post, Events.Posts.Post

    timestamps()
  end

  @doc false
  def changeset(invitee, attrs) do
    invitee
    |> cast(attrs, [:email, :post_id])
    |> validate_required([:email, :post_id])
  end
end
