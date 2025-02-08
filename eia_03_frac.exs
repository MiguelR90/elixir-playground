defmodule Fraction do
  defstruct a: nil, b: nil
end

defmodule App do
  def run do
    %Fraction{} |> IO.inspect(structs: false)
  end
end

App.run()
