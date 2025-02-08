defmodule ElixirPlaygroundTest do
  use ExUnit.Case
  doctest ElixirPlayground

  test "greets the world" do
    assert ElixirPlayground.hello() == :world
  end
end
