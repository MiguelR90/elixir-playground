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

defmodule TodoList.CsvImporter do
  defp line_to_map(entry_str, keys) when is_bitstring(entry_str) do
    values = String.split(entry_str, ",")

    if keys do
      Map.new(Enum.zip(keys, values))
    else
      # Enum.with_index() requires a swap when building a map with indexes as keys
      Map.new(
        Enum.with_index(values)
        |> Enum.map(fn {item, index} -> {index, item} end)
      )
    end
  end

  def import(path, keys? \\ true) do
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
      |> Stream.map(&line_to_map(&1, keys))
      |> TodoList.new()
    else
      File.stream!(path)
      |> Stream.map(&String.trim_trailing(&1))
      |> Stream.map(&line_to_map(&1, nil))
      |> TodoList.new()
    end
  end
end

# nice but i have a feeling that it can be just so so much better
defmodule Main do
  def run do
    TodoList.new([%{name: "alejandra"}, %{name: "mabel"}, %{name: "titi"}])
    |> TodoList.add_entry(%{name: "miguel"})
    |> IO.inspect()
    |> TodoList.add_entry(%{name: "elyn"})
    |> IO.inspect()
    |> TodoList.update_entry(1, %{age: 34, lang: "elixir", likes: "bikes"})
    |> IO.inspect()
    |> TodoList.update_entry(2, %{age: 2, lang: "spanish", likes: "piggy"})
    |> IO.inspect()
    |> TodoList.delete_entry(1)
    |> IO.inspect()
    |> TodoList.add_entry(%{name: "lydia"})
    |> IO.inspect()

    TodoList.CsvImporter.import("todo_list.csv", true)
    |> IO.inspect()

    TodoList.CsvImporter.import("todo_list2.csv", false)
    |> IO.inspect()
  end
end

Main.run()
