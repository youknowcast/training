defmodule Ch01BasicsTest do
  use ExUnit.Case

  test "2+3 =5" do
    assert(2 + 3 == 5)
  end

  test "bit, oct, hex" do
    assert(0b0110 == 6)
    assert(0o644 == 420)
    assert(0x1F == 31)
  end

  test "float" do
    assert(3.14 == 3.14)
    assert(Float.parse(".14") == :error)
  end

  test "atom, bool" do
    assert(true == true)
    assert(false == false)
    assert(is_atom(true) == true && is_atom(false) == true)
    assert(is_boolean(true) == true && is_boolean(false) == true)

    defmodule Foo do
    end

    assert(is_atom(Foo) == true)
    # not declared module also be atom
    assert(is_atom(Bar) == true)
  end

  test "string" do
    # compare each codepoint
    assert(String.to_charlist("HELLO") == [72, 69, 76, 76, 79])
    # ? returns code point
    assert(?保 == 20445)

    assert(String.length("安保理") == 3)
    assert(byte_size("安保理") == 9)

    # https://hexdocs.pm/elixir/String.html#valid?/1-examples
    %{
      "a" => true,
      "φ" => true,
      <<0xFFFF::16>> => false,
      <<0xEF, 0xB7, 0x90>> => true,
      ("asd" <> <<0xFFFF::16>>) => false
    }
    |> Enum.each(fn {k, v} -> assert(String.valid?(k) == v) end)
  end

  describe "collection" do
    test "List" do
      word = "apple"
      list = ["neun", :eight, 7]

      assert(["apple", "neun", :eight, 7] == [word | list])
      assert(list ++ [word] == ["neun", :eight, 7, "apple"])
      assert(list -- [:eight] == ["neun", 7])

      # comparation uses strict comparison
      assert([2] -- [2] == [])
      assert([2] -- [2.0] == [2])
      assert([2.0] -- [2] == [2.0])
      assert([2.0] -- [2.0] == [])

      assert(hd(list) == "neun")
      assert(tl(list) == [:eight, 7])
      [h | t] = list
      assert(h == "neun" and t == [:eight, 7])

      # keyword-list is list of tuples
      assert([hoge: :huga, moge: :mage] == [{:hoge, :huga}, {:moge, :mage}])

      assert([hoge: :huga, hoge: :huga2] |> Enum.count(fn x -> elem(x, 0) == :hoge end) == 2)
    end

    test "Tuple" do
      tuple = {:one, :two, :three}

      # raises if length is not match
      assert_raise(MatchError, fn -> {_a, _b} = tuple end)
    end

    test "Map" do
      map = %{:hoge => :huga, "moge" => :mage}
      assert(map[:hoge] == :huga)
      assert(map["moge"] == :mage and map[:moge] == nil)

      key = :key
      map2 = %{key => "word"}
      assert(map2 = %{:key => "word"})

      assert(%{:hoge => :huga, :hoge => :huga2} == %{:hoge => :huga2})

      map3 = %{hoge: :huga, moge: :mage}
      assert(map3 == %{:hoge => :huga, :moge => :mage})

      # like js spread syntax but elixir allows update value only
      map4 = %{map3 | hoge: :huga2}
      assert(map4 == %{hoge: :huga2, moge: :mage})
      assert_raise(KeyError, fn -> %{map4 | foo: :bar} end)

      assert(Map.put(map4, :foo, :bar) == %{hoge: :huga2, moge: :mage, foo: :bar})
    end

    test "Enum" do
      l = fn x -> String.length(x) end

      assert(Enum.all?(["foo", "bar", "hello"], fn s -> l.(s) == 3 end) == false)
      assert(Enum.all?(["foo", "bar", "hello"], fn s -> l.(s) > 1 end) == true)

      assert(Enum.any?(["foo", "bar", "hello"], fn s -> l.(s) == 5 end) == true)
      assert(Enum.any?(["foo", "bar", "hell"], fn s -> l.(s) == 5 end) == false)

      # Enum.each returns :ok
      assert(Enum.each(["one", "two", "three"], fn _ -> nil end) == :ok)

      assert(Enum.map([0, 1, 2, 3], fn x -> x - 1 end) == [-1, 0, 1, 2])

      assert(Enum.min([5, 3, 0, -1]) == -1)
      assert(Enum.max([5, 3, 0, -1]) == 5)

      # min/2 and max/2 returns default value if []
      assert(Enum.min([], fn -> :empty end) == :empty)
      assert(Enum.max([], fn -> :empty end) == :empty)
      assert(Enum.min([1, 2, 3], fn -> :empty end) == 1)
      assert(Enum.max([1, 2, 3], fn -> :empty end) == 3)

      assert(Enum.filter([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end) == [2, 4])

      assert(Enum.reduce([1, 2, 3], 10, fn x, acc -> x + acc end) == 16)
    end

    def function_fnc3(n), do: n * 2

    def function_fnc4(n) do
      n * 2
    end
  end

  test "function" do
    fnc = fn x -> x * 2 end
    fnc2 = &(&1 * 2)
    fnc5 = &Ch01BasicsTest.function_fnc3(&1)
    fnc6 = &Ch01BasicsTest.function_fnc3/1

    [fnc.(5), fnc2.(5), function_fnc3(5), function_fnc4(5), fnc5.(5), fnc6.(5)]
    |> Enum.each(fn x ->
      assert(x == 10)
    end)
  end

  test "pattern-match" do
    list = [1, 2, 3]
    assert(list == [1, 2, 3])
    assert_raise(MatchError, fn -> ^list = [3, 4, 5] end)

    key = "hello"
    %{^key => value} = %{"hello" => "world"}
    assert(key == "hello" and value == "world")

    # at function
    greeting = "Hello"

    greet = fn
      ^greeting, name -> "Hi #{name}"
      greeting, name -> "#{greeting} #{name}"
    end

    assert(greet.("Hello", "Sean") == "Hi Sean")
    assert(greet.("Mornin", "Sean") == "Mornin Sean")
  end

  describe "if/case/cond" do
    test "if" do
      fnc = fn s ->
        if String.valid?(s) do
          "Valid string"
        else
          "Invalid string"
        end
      end

      assert(fnc.("hello") == "Valid string")
      assert(fnc.(1) == "Invalid string")

      fnc2 = fn s ->
        if s do
          "Valid"
        else
          "Invalid"
        end
      end

      assert(fnc2.("hello") == "Valid")
      assert(fnc2.(:hello) == "Valid")
      assert(fnc2.([1]) == "Valid")
      assert(fnc2.([]) == "Valid")
      assert(fnc2.({:ok}) == "Valid")
      assert(fnc2.(%{hoge: :huga}) == "Valid")
      assert(fnc2.(%{}) == "Valid")
      assert(fnc2.(nil) == "Invalid")
      assert(fnc2.(false) == "Invalid")
    end

    test "case" do
      fnc = fn s ->
        case s do
          {:ok, result} -> result
          {:error} -> "Uh oh!"
          _ -> "Catch all"
        end
      end

      assert(fnc.({:ok, "hello world"}) == "hello world")
      assert(fnc.({:error}) == "Uh oh!")
      assert(fnc.("hoge") == "Catch all")

      # with guard
      fnc = fn x ->
        case x do
          {1, x, 3} when x > 0 ->
            "Will match"

          _ ->
            "Won't match"
        end
      end

      assert(fnc.({1, 2, 3}) == "Will match")
      assert(fnc.({1, -1, 3}) == "Won't match")
      assert(fnc.({1, 3, 2}) == "Won't match")
    end

    test "cond" do
      fnc = fn ->
        cond do
          2 + 2 == 5 ->
            "This will not be true"

          2 * 2 == 3 ->
            "Nor this"

          1 + 1 == 2 ->
            "But this will"
        end
      end

      assert(fnc.() == "But this will")

      # true means `default`
      fnc2 = fn ->
        cond do
          7 + 1 == 0 -> "Incorrect"
          true -> "Catch all"
        end
      end

      assert(fnc2.() == "Catch all")
    end

    # TODO: with syntax
  end
end
