defmodule Contacts.Contacts do
  use Ecto.Schema

  schema "contacts" do
    field(:window_open, :utc_datetime)
    field(:window_close, :utc_datetime)
    field(:sat_id, :string)
    field(:groundstation, :string)
  end
end
