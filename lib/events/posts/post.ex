defmodule Events.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :title, :string
    field :date, :string

    belongs_to :user, Events.Users.User
    has_many :comments, Events.Comments.Comment
    has_many :invitees, Events.Invitees.Invitee
    has_many :responses, Events.Responses.Response

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :title, :date, :user_id])
    |> validate_required([:body, :title, :date, :user_id])
  end
end
