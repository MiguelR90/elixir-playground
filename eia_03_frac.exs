defmodule Fraction do
  defstruct a: nil, b: nil

  def new(a, b) do
    %Fraction{a: a, b: b}
  end

  # pattern matching in the function signature is very powerful
  # makes it very explicit what inputs we expect
  def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
    a = a1 * b2 + a2 * b1
    b = b1 * b2
    # TODO: consider simplifying the fraction
    %Fraction{a: a, b: b}
  end

  def value(%Fraction{a: a, b: b}) do
    a / b
  end
end

defmodule App do
  def run do
    Fraction.new(1, 4)
    |> IO.inspect()
    |> Fraction.add(Fraction.new(1, 4))
    |> IO.inspect()
    |> Fraction.add(Fraction.new(1, 2))
    |> IO.inspect()
    |> Fraction.value()
    |> IO.inspect()
  end
end

App.run()
