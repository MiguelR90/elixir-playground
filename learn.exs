{:ok, content} = File.read("example.json")
{:ok, json} = JSON.decode(content)
names = json |> Enum.map(& &1["first"])
IO.puts(names)
IO.puts(json |> Enum.map(& &1["first"]))

# erljson = :json.decode(content)

IO.puts(:json.decode(content) |> Enum.map(& &1["first"]))
IO.puts(inspect(Enum.at(:json.decode(content), 0)))
# first = Enum.at(:json.decode(content), 0)

# this requires the "first"
first = %{"first" => "miguel", "last" => "rodriguez"}
IO.puts(first["first"])

# this let's you do the .first
first = %{:first => "miguel", :last => "rodriguez"}
IO.puts(first.first)

# oh it's because keylist are list of tuples where the first element in the tuple is an atom
IO.puts([{:hello, "world"}] == [hello: "world"])
[{:hello, world}] = [hello: "world"]
IO.puts(world)

# Much nicer way to iterate over file content
IO.puts(
  "example.json"
  |> File.read!()
  |> :json.decode()
  |> Enum.map(&(&1["first"] <> &1["last"]))
)

defmodule Person do
  # check ensure first and last are set
  @enforce_keys [:first, :last]
  defstruct [:first, :last]
end

defmodule Main do
  def run do
    # This works
    # person = %Person{:first => "miguel", :last => "rodriguez"}
    # This works as well
    person = %Person{first: "miguel", last: "rodriguez"}
    IO.inspect(person)
  end
end

IO.puts("Running main...")
Main.run()
