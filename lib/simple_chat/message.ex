defmodule SimpleChat.Message do
  use Ecto.Schema

  import Ecto.Changeset

  alias SimpleChat.Repo
  alias __MODULE__
  import Ecto.Query, only: [from: 2]

  schema "messages" do
    field :author_name, :string
    field :content, :string

    field :room_name, :string

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, ~w(content room_name author_name)a)
    |> validate_required(~w(content room_name author_name)a)
  end

  def last_in(room_name, count \\ 10) do
    Repo.all(
      from m in Message,
        where: m.room_name == ^room_name,
        order_by: [desc: m.inserted_at],
        limit: ^count
    )
  end

  def create(attrs) do
    %Message{}
    |> changeset(attrs)
    |> Repo.insert!()
  end
end
