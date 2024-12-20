defmodule Contacts.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add(:window_open, :utc_datetime)
      add(:window_close, :utc_datetime)
      add(:sat_id, :string)
      add(:groundstation, :string)
    end
  end
end
