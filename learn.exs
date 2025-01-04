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

# Comprehensions
IO.puts("Learning about comprehensions...")
data = for n <- 1..10, do: n * 2
IO.puts(data |> Enum.join(", "))
# IO.inspect(data) adds a bunch of lines before print to stdin

# something about the :into option during comprehensions
# stream = IO.stream(:stdio, :line)

# for line <- stream, into: stream do
#   String.upcase(line) <> "\n"
# end

# Regular expression as first class citizens of the language (inspired by perl)
# i stands for case insensitive
regex = ~r/miguel|elyn/i
check = "miguel" =~ regex
IO.puts(check)
check = "Elyn (Emmie) Rodriguez" =~ regex
IO.puts(check)

# Charlist (i still don't quite understand the difference between this and regular strings)
value = ~c"cat"
IO.puts(value)

# String (convenient w/ double quotes strings)
value = ~s(this is a string with "double quotes" and 'single' too)
IO.puts(value)

# Word list (this seems super convenient) sep by blank line (?)
values = ~w(miguel elyn emmie lydia)
IO.puts(values |> Enum.join("\n"))

multiline = ~s"""
this is a multiline string
more lines
another  one

one in between
"""

IO.puts(multiline)

# Sigils can be used for datetimes as well !!! nuts
datetime = ~U[2019-10-31 19:59:03Z]
IO.puts(datetime)

# Erlang modules can be accessed by the :atom sytax
:io.format("Pi is approximately give by: ~10.3f~n", [:math.pi()])

# Erlang has a (in-memory or disk) data storage called :ets or :dets respectively
# Stands for Erlang Term Storage (think of it as a key value pair storage)
# table = :ets.new(:ets_test, [])
# :ets.insert(table, {"China", 1.374})
# :ets.insert(table, {"India", 1.284})
# :ets.insert(table, {"USA", 0.322})
# data = :ets.i(table, 0)
# IO.puts(data)
# Not sure why this wasn't working
