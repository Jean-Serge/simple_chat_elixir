defmodule SimpleChatWeb.RoomChannel do
  use SimpleChatWeb, :channel

  alias SimpleChat.Message

  @impl true
  def join("room:" <> _room, payload, socket) do
    if authorized?(payload) do
      send(self(), :joined)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl Phoenix.Channel
  def handle_info(:joined, socket) do
    messages = Message.last()

    messages
    |> Enum.reverse()
    |> Enum.each(&push(socket, "new_msg", %{body: &1.content}))

    {:noreply, socket}
  end

  @impl Phoenix.Channel
  @spec handle_in(<<_::56>>, map, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_in("new_msg", %{"body" => body}, socket) do
    Message.create(%{content: body})

    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
