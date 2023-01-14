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
    assert(String.to_charlist("HELLO") == [72, 69, 76, 76,79])
  end
end
