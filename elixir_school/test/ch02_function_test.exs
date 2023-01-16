defmodule Ch02FunctionTest do
  use ExUnit.Case

  defp phrase("en"), do: "hello"
  defp phrase("es"), do: "hola"
  defp phrase("ja"), do: "こんにちは"
  defp phrase(_), do: "cannot understand.."

  defp foo(a, b \\ :default), do: {a, b}

  test "args" do
    %{
      "en" => "hello",
      "es" => "hola",
      "ja" => "こんにちは",
      "jar" => "cannot understand.."
    }
    |> Enum.each(fn {k, v} ->
      assert(phrase(k) == v)
    end)

    assert(foo(:bar) == {:bar, :default})
    assert(foo(:bar, :baz) == {:bar, :baz})
    # default argument is counted as arity, so foo/2 is right.
    # the way to check defined function:
    # see: https://stackoverflow.com/questions/43881290/in-elixir-is-there-a-way-to-determine-if-a-module-exists
    assert(function_exported?(__MODULE__, :foo, 1) == false)
    assert(function_exported?(__MODULE__, :foo, 2) == false)
  end
end
