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

# Anonymous function are function not attached to modules
myfunc = fn x -> "IO str: " <> x end
IO.puts(is_function(myfunc))

1..3 |> Enum.map(fn _x -> IO.puts("inside map") end)
# can be accomplished by Enum.each as well not sure the difference
# 1..3 |> Enum.map(fn _x -> IO.puts("inside map") end)

IO.puts(1..10 |> Enum.map(fn x -> String.Chars.to_string(x) end))

# If you want to run it in a script you have to wrap it into a module
defmodule Utils do
  def prefix(x) do
    # this will be computed but ignored
    "IO str: " <> x
    # you can do this with string interpolation as well
    "IO str: #{x}"
  end
end

string = Utils.prefix("hello world")
IO.puts(string)

# Protocols the way to implement interfaces
defprotocol Utility do
  # this spec syntax is for documentation purposes and is not needed
  @spec type(t) :: String.t()
  def type(value)
end

# This is an implementation of the protocol for bitstrings
# not sure what the difference is between bitstring and strings are
# but it works as you'd expect
defimpl Utility, for: BitString do
  def type(_value), do: "input was string"
end

defimpl Utility, for: Integer do
  def type(_value), do: "input was integer"
end

IO.puts(Utility.type("hello world"))
IO.puts(Utility.type(1234))

# map sets are the sets in elixir
set =
  MapSet.new()
  |> MapSet.put(1)
  |> MapSet.put(2)
  |> MapSet.put(3)
  |> MapSet.put(4)
  |> MapSet.put(4)
  |> MapSet.put(4)
  |> MapSet.put(4)

# prints a debugging stack
dbg(set)

# Extend protocol implementation with map set
defimpl Utility, for: MapSet do
  def type(_value), do: "input is MapSet"
end

IO.puts(Utility.type(set))

# IO inspect can be places in between transform pipelines
1..10 |> IO.inspect(label: "before") |> Enum.sum() |> IO.inspect(label: "after")
