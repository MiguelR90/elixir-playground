defmodule MessagePassing do
  def run do
    # NOTE: sending and receiving a message to and from the same process
    send(self(), {:message, "hello world"})

    receive do
      {:message, value} ->
        IO.puts("Received message: #{value}")

      # NOTE: best practice to have a "catch all" to avoid stuck messages
      _ ->
        IO.puts("Warning unmatched message")
    end
  end
end

MessagePassing.run()
