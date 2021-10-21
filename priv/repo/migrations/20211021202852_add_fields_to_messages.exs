defmodule SimpleChat.Repo.Migrations.AddFieldsToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :room_name, :string
    end

    create index(:messages, :room_name)
  end
end
