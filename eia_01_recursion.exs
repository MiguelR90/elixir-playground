# These version are not optimized with tail recursion

defmodule ListHelper do
  def list_len([]) do
    0
  end

  def list_len([_ | tail]) do
    1 + list_len(tail)
  end
end

ListHelper.list_len([1, 2, 3]) |> IO.inspect()
ListHelper.list_len([1]) |> IO.inspect()
ListHelper.list_len([]) |> IO.inspect()

defmodule RangeHelper do
  def range(a, b) when a == b do
    [a]
  end

  def range(a, b) when a < b do
    [a | range(a + 1, b)]
  end

  def range(a, b) when a > b do
    [a | range(a - 1, b)]
  end
end

RangeHelper.range(1, 10) |> IO.inspect()
RangeHelper.range(0, -5) |> IO.inspect()

defmodule PositiveHelper do
  def positive([]) do
    []
  end

  def positive([head | tail]) when head <= 0 do
    positive(tail)
  end

  def positive([head | tail]) when head > 0 do
    [head | positive(tail)]
  end
end

PositiveHelper.positive([-1, 0, 1, 2, 3]) |> IO.inspect()
PositiveHelper.positive([1, -6, 2, -9, 3, -10]) |> IO.inspect()
PositiveHelper.positive([]) |> IO.inspect()
