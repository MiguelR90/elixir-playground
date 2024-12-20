defmodule Contacts.Repo do
  use Ecto.Repo,
    otp_app: :elixir_playground,
    adapter: Ecto.Adapters.SQLite3
end
