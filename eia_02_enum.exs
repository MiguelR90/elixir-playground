defmodule FileHelper do
  def large_lines(path) do
    File.stream!(path)
    # Removes the trailing new line since empty lines are consider of size 1 otherwise
    |> Stream.map(&String.trim_trailing(&1))
    |> Enum.map(&String.length(&1))
  end

  def longest_line_length(path) do
    # there is obviously Enum.max() but avoid that to get practice
    large_lines(path) |> Enum.reduce(&max(&1, &2))
    # what is the syntax for anonymous functions because i'm not sure how to write them
  end

  defp max_length_reducer(str1, str2) do
    if String.length(str1) <= String.length(str2) do
      str2
    else
      str1
    end
  end

  def longest_line(path) do
    File.stream!(path)
    |> Stream.map(&String.trim_trailing(&1))
    |> Enum.reduce(&max_length_reducer(&1, &2))
  end

  def words_per_line(path) do
    File.stream!(path)
    |> Stream.map(&String.trim(&1))
    # |> Stream.map(&String.split(&1))
    # |> Enum.map(&length(&1))
    |> Enum.map(fn x -> length(String.split(x)) end)
  end
end

FileHelper.large_lines("test.txt") |> IO.inspect()
FileHelper.longest_line_length("test.txt") |> IO.inspect()
str = FileHelper.longest_line("test.txt") |> IO.inspect()
String.length(str) |> IO.inspect()
FileHelper.words_per_line("test.txt") |> IO.inspect()
