defmodule ElixirPlayground do
  use Application

  def start(_type, _args) do
    IO.puts("hello world")

    ElixirPlayground.main()
    # This is here to satisfy the app start API
    # app callback must return a supervisor tree
    # children = [Contacts.Repo]
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main do
    json_str = Jason.encode!(%{1 => 1, 2 => 2})
    IO.puts(json_str)

    contact = %Contacts.Contacts{sat_id: "c14", groundstation: "ohio"}
    Contacts.Repo.start_link()
    Contacts.Repo.insert(contact)
  end
end
