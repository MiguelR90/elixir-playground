defmodule TodoList do
  defstruct next_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn entry, todo_list -> add_entry(todo_list, entry) end
    )
  end

  def add_entry(%TodoList{next_id: next_id} = todo_list, %{} = entry) do
    # NOTE: update technique is known as: Immutable hierarchical updates
    # Access.key! return a func that let's us access struct fields dynamically
    # Raises and error if key is not found
    todo_list
    |> put_in([Access.key!(:entries), next_id], entry)
    |> update_in([Access.key!(:next_id)], &(&1 + 1))
  end

  def update_entry(%TodoList{} = todo_list, id, %{} = updates) when is_integer(id) do
    # NOTE: equivalent to -> update_in(todo_list.entries[id], &Map.merge(&1, updates))
    update_in(todo_list, [Access.key!(:entries), id], &Map.merge(&1, updates))
  end

  def delete_entry(%TodoList{} = todo_list, id) when is_integer(id) do
    # NOTE: Pop_in return the entry; ignore it with a _
    {_, new_todo_list} = pop_in(todo_list.entries[id])
    new_todo_list
  end
end

defmodule TodoList.CsvReader do
  defp decode(entry_str, nil) when is_bitstring(entry_str) do
    values = String.split(entry_str, ",")
    keys = 0..length(values)
    Map.new(Enum.zip(keys, values))
  end

  defp decode(entry_str, keys) when is_bitstring(entry_str) and is_list(keys) do
    values = String.split(entry_str, ",")
    Map.new(Enum.zip(keys, values))
  end

  def read!(path, keys? \\ true) do
    if keys? do
      keys =
        File.stream!(path)
        |> Enum.fetch!(0)
        |> String.trim_trailing()
        |> String.split(",")

      # NOTE: not sure how to incrementally stream to avoid dropping first line
      File.stream!(path)
      |> Stream.drop(1)
      |> Stream.map(&String.trim_trailing(&1))
      |> Stream.map(&decode(&1, keys))
      |> TodoList.new()
    else
      File.stream!(path)
      |> Stream.map(&String.trim_trailing(&1))
      |> Stream.map(&decode(&1, nil))
      |> TodoList.new()
    end
  end
end

# NOTE: ex of impl String.Chars.to_string protocol for TodoList
defimpl String.Chars, for: TodoList do
  def to_string(%TodoList{} = todo_list) do
    "#{inspect(todo_list, pretty: true)}"
  end
end

# NOTE: Collectable protocol which extends TodoLists with Enum.into functionality
defimpl Collectable, for: TodoList do
  def into(original) do
    {original, &into_callback/2}
  end

  # NOTE: Alternative this can be an anonymous func in the into call itself
  # Ref: https://hexdocs.pm/elixir/Collectable.html
  defp into_callback(todo_list, {:cont, entry}), do: TodoList.add_entry(todo_list, entry)
  defp into_callback(todo_list, :done), do: todo_list
  defp into_callback(_todo_list, :halt), do: :ok
end

ExUnit.start()

defmodule AssertionTest do
  # NOTE: that we pass "async: true", this runs the tests in the
  # test module concurrently with other test modules. The 
  # individual tests within each test module are still run serially.
  use ExUnit.Case, async: true

  test "todo new" do
    todo_list = TodoList.new([%{name: "alejandra"}, %{name: "mabel"}, %{name: "titi"}])
    assert map_size(todo_list.entries) == 3
    assert todo_list.next_id == 4
  end

  test "todo add_entry" do
    todo_list = TodoList.new() |> TodoList.add_entry(%{name: "miguel"})
    assert map_size(todo_list.entries) == 1
    assert todo_list.next_id == 2
  end

  test "todo delete_entry" do
    todo_list = TodoList.new([%{name: "test_entry"}]) |> TodoList.delete_entry(1)
    assert map_size(todo_list.entries) == 0
  end

  test "todo update_entry" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{name: "miguel"})
      |> TodoList.update_entry(1, %{age: 34, lang: "elixir", likes: "bikes"})

    assert map_size(todo_list.entries[1]) == 4
  end

  test "todo csv reader with headers" do
    todo_list = TodoList.CsvReader.read!("todo_list.csv", true)
    assert map_size(todo_list.entries) == 3
  end

  test "todo csv reader without headers" do
    todo_list = TodoList.CsvReader.read!("todo_list2.csv", false)
    assert map_size(todo_list.entries) == 3
  end

  test "todo Enum.into protocol" do
    entries = [%{name: "alejandra"}, %{name: "mabel"}, %{name: "titi"}]
    todo_list = Enum.into(entries, TodoList.new())
    assert map_size(todo_list.entries) == 3
  end
end
