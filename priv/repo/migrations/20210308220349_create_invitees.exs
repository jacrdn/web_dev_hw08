defmodule Events.Repo.Migrations.CreateInvitees do
  use Ecto.Migration

  def change do
    create table(:invitees) do
      add :email, :text


      add :post_id,
        references(:posts, on_delete: :delete_all),
        null: false

      timestamps()
    end

    create index(:invitees, [:post_id])

  end
end
