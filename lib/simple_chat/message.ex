defmodule SimpleChat.Message do
  use Ecto.Schema

  import Ecto.Changeset

  alias SimpleChat.Repo
  alias __MODULE__
  import Ecto.Query, only: [from: 2]

  schema "messages" do
    field :author_name, :string
    field :content, :string

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, ~w(content)a)
    |> validate_required(~w(content)a)
  end

  def last(count \\ 10) do
    Repo.all(
      from m in Message,
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
