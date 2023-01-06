ExUnit.start()

defmodule TestBoolean do
  use ExUnit.Case

  test "and/or" do
    assert((true and true) == true)
    assert((true and false) == false)
    assert((false and false) == false)
    assert((true or false) == true)
  end

  test "and is prior to or" do
    assert((true or true and false) == true)
  end

  test "and disallows ambiguous comparation" do
    assert_raise BadBooleanError, fn -> :ok and true end
    assert_raise BadBooleanError, fn -> :ok and false end

    assert((true and :ok) == :ok)
    assert((false and :ok) == false)
  end

  test "&& allows ambiguous comparation" do
    assert((:ok && true) == true)
    assert((:ok && false) == false)

    assert((true && :ok) == :ok)
    assert((false && :ok) == false)

    assert((nil && :ok) == nil)
    # false でも nil でもない値であれば真値として扱い，右辺を返却する
    assert((:ok && :ng) == :ng)
  end
end

defmodule TestModule.Sample do
  def multiply(a, b), do: a * b
  def multiply(a, b, c), do: a * b * c

  def connect(a, b) do
    a <> "-" <> b
  end

  def connect2(list) do
    list[:a] <> "-" <> list[:b]
  end
end

defmodule TestModule do
  use ExUnit.Case

  test "apply/2" do
    multiply = fn a, b -> a * b end
    assert(apply(multiply, [3, 5]) == 15)
  end

  test "apply/3" do
    assert(apply(TestModule.Sample, :multiply, [2, 3, 4]) == 24)
  end

  test "q.8-4-1" do
    subtract = fn a, b -> a - b end
    assert(subtract.(5, 3) == 2)
  end

  test "q.8-4-2, 3" do
    list = ["X", "Y"]
    assert(apply(TestModule.Sample, :connect, list) == "X-Y")
    list2 = [a: "X", b: "Y"]
    assert(apply(TestModule.Sample, :connect2, [list2]) == "X-Y")
  end

  test "capture" do
    func = &TestModule.Sample.multiply/2
    assert(func.(5, 3) == 15)

    func2 = &[&1, &2]
    assert(func2.(:a, :b) == [:a, :b])

    func3 = &{&1, &2}
    assert(func3.(:a, :b) == {:a, :b})

    func4 = &%{&1 => &2}
    assert(func4.(:a, :b) == %{:a => :b})
  end
end

defmodule TestList do
  use ExUnit.Case

  test "ascii" do
    assert([60, 70, 90] == '<FZ')
    assert([60, 70, 90] == [60, 70, 90])
  end

  test "non-ascii" do
    assert([60, 1, 90] == [60, 1, 90])
  end
end



