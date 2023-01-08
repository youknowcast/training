defmodule Sequence.ServerTest do
  use ExUnit.Case
  doctest Sequence.Server

  test "greets the world" do
    assert Sequence.hello() == :world
  end
end
