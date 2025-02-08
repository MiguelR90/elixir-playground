defmodule TodoList do
  defstruct next_id: 1, entries: %{}

  def new do
    %TodoList{}
  end

  def add_entry(todo_list, entry) do
    entries = Map.put(todo_list.entries, todo_list.next_id, entry)
    %TodoList{next_id: todo_list.next_id + 1, entries: entries}
  end

  # Elixir has a much better api under: Immutable hierarchical updates
  def update_entry(todo_list, id, updates) do
    case Map.fetch(todo_list.entries, id) do
      :error ->
        todo_list

      {:ok, entry} ->
        new_entry = Map.merge(entry, updates)
        new_entries = Map.put(todo_list.entries, id, new_entry)
        %TodoList{next_id: todo_list.next_id, entries: new_entries}
    end
  end

  def delete_entry(todo_list, id) do
    entries = Map.delete(todo_list.entries, id)
    %TodoList{next_id: todo_list.next_id, entries: entries}
  end
end

# nice but i have a feeling that it can be just so so much better
defmodule Main do
  def run do
    TodoList.new()
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
  end
end

Main.run()
