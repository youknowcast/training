defmodule Ch03PipelineOperatorTest do
  use ExUnit.Case

  test "" do
    assert("Elixir rocks" |> String.upcase() |> String.split() == ["ELIXIR", "ROCKS"])
    assert("elixir" |> String.ends_with?("ixir") == true)
  end
end
