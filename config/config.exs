import Config

# In memory db needs pool size set to 1
config :elixir_playground, Contacts.Repo,
  database: "/tmp/elixir-playground.sqlite3",
  journal_mode: :wal,
  pool_size: 1

config :elixir_playground, ecto_repos: [Contacts.Repo]
