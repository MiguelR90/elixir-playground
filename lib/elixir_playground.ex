defmodule ElixirPlayground do
  use Application

  def start(_type, _args) do
    # This is here to satisfy the app start API
    # app callback must return a supervisor tree
    IO.puts("Starting app supervisor...")
    children = [Contacts.Repo]
    opts = [strategy: :one_for_one, name: ElixirPlayground.Supervisor]
    supervisor = Supervisor.start_link(children, opts)

    # Now that supervisor is up and running we can call main
    ElixirPlayground.main()

    # The supervisor needs to be returned at the end of start method
    supervisor
  end

  def main do
    json_str = Jason.encode!(%{1 => 1, 2 => 2})
    IO.puts(json_str)

    contact = %Contacts.Contacts{sat_id: "c14", groundstation: "ohio"}
    Contacts.Repo.insert(contact)
  end
end
