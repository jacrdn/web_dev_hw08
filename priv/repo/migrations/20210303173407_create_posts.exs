defmodule Events.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      # implicit :id, :integer, auto_increment

      add :body, :text, null: false
      add :title, :string, null: false
      add :date, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps() # created_at, updated_at
    end

  end
end
