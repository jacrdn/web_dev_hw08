defmodule Events.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :response, :text

      add :post_id,
        references(:posts, on_delete: :delete_all),
        null: false
      add :user_id,
        references(:users, on_delete: :delete_all),
        null: false

      timestamps()
    end

    create index(:responses, [:post_id])
    create index(:responses, [:user_id])
  end
end
