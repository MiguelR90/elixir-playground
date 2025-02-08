defmodule TodoList do
  defstruct next_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn entry, todo_list -> add_entry(todo_list, entry) end
    )
  end

  def add_entry(todo_list, entry) do
    %TodoList{
      next_id: todo_list.next_id + 1,
      entries: Map.put(todo_list.entries, todo_list.next_id, entry)
    }
  end

  def update_entry(todo_list, id, updates) do
    # Is checking for existance more efficient than fetching
    case Map.fetch(todo_list.entries, id) do
      {:ok, entry} ->
        put_in(todo_list.entries[id], Map.merge(entry, updates))

      :error ->
        todo_list
    end
  end

  def delete_entry(todo_list, id) do
    # Pop return the entry; ignore it with a _
    {_, new_todo_list} = pop_in(todo_list.entries[id])
    new_todo_list
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
  end
end

Main.run()
