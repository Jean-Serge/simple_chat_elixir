defmodule SimpleChatWeb.RoomChannel do
  use SimpleChatWeb, :channel

  alias SimpleChat.Message

  @impl true
  def join("room:" <> topic_name = room_name, _payload, socket) do
    if authorized?(socket, topic_name) do
      send(self(), {:joined, room_name})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl Phoenix.Channel
  def handle_info({:joined, room_name}, socket) do
    messages = Message.last_in(room_name)

    messages
    |> Enum.reverse()
    |> Enum.each(&push(socket, "new_msg", &1))

    {:noreply, socket}
  end

  @impl Phoenix.Channel
  def handle_in("new_msg", %{"content" => content}, socket) do
    message =
      Message.create(%{
        content: content,
        author_name: socket.assigns[:current_user],
        room_name: socket.topic
      })

    broadcast!(socket, "new_msg", message)

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(%{assigns: %{current_user: current_user}}, room_name) do
    current_user in String.split(room_name, ":", parts: 2)
  end
end
