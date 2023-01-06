ExUnit.start(exclude: :not_implemented)

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

  test "sort" do
    list1 = [3, 5, -1, 0, 7]
    list2 = ["bob", "eve", "carol", "alice", "david"]
    list3 = ["1", "10", "2", "1000", "3", "-1"]

    assert(Enum.sort(list1) == [-1, 0, 3, 5, 7])
    assert(Enum.sort(list1, :desc) == Enum.reverse([-1, 0, 3, 5, 7]))
    assert(Enum.sort(list2) == ["alice", "bob", "carol", "david", "eve"])
    assert(Enum.sort(list2, :desc) == Enum.reverse(["alice", "bob", "carol", "david", "eve"]))

    assert(Enum.sort(list3) == ["-1", "1", "10", "1000", "2", "3"])
    assert(Enum.sort(list3, fn a, b -> String.to_integer(a) <= String.to_integer(b) end) == ["-1", "1", "2", "3", "10", "1000"])
  end

  test "Enum.random" do
    list = [3, 5, 6, 9]
    assert(Enum.random(list) in list)
    assert_raise(Enum.EmptyError, fn -> Enum.random([]) end)
  end

  test "one?" do
    one? = fn list -> Enum.reduce(list, false, fn v, acc -> v || acc end) end
    assert(one?.([false, false, true, false]) == true)
    assert(one?.([false, false, false, false]) == false)
    assert(one?.([]) == false)
  end

  test "q.17-7-1" do
    result = 
      [-1, 1, 1, -2, 0, 4, 3, 1, 0, 3]
      |> Enum.filter(fn n -> n >= 1 end)
      |> Enum.uniq()
      |> Enum.sort(:desc)
    assert(result == [4, 3, 1])
  end

  test "q.17-7-2" do
    triple_each = fn list -> Enum.map(list, fn n -> n * 3 end) end
    assert(triple_each.([1, 5, -2, 0, 17]) == [3, 15, -6, 0, 51])
  end
end

defmodule TestMacro do
  use ExUnit.Case

  test "generator" do
    val = for n <- 1..10 do
      n - 1
    end
    assert(val == Enum.to_list(0..9))

    # with `filter`
    val2 = for n <- 0..10, rem(n, 3) == 0 do
      n - 1
    end
    assert(val2 == [-1, 2, 5, 8])
  end

  test "multi generator" do
    val = for a <- 0..3, b <- 4..5 do
      {a, b}
    end
    assert(val == [{0, 4}, {0, 5}, {1, 4}, {1, 5}, {2, 4}, {2, 5}, {3, 4}, {3, 5}])

    val2 = for a <- 0..3, b <- 4..5, rem(a * b, 5) == 0 do
      {a, b}
    end
    assert(val2 == [{0, 4}, {0, 5}, {1, 5}, {2, 5}, {3, 5}])
  end

  test "with" do
    sample = "value=9999"
    pseudo_file_result_ok = {:ok, sample}

    val = with {:ok, data} <- pseudo_file_result_ok,
         "value=" <> value <- data,
         value = String.trim(value),
         {n, _} <- Integer.parse(value) do
      n
    else
      _ -> nil
    end
    assert(val == 9999)

    pseudo_file_result_ng = {:ng, sample}
    val2 = with {:ok, data} <- pseudo_file_result_ng,
         "value=" <> value <- data,
         value = String.trim(value),
         {n, _} <- Integer.parse(value) do
      n
    else
      _ -> nil
    end
    assert(val2 == nil)
  end
end

defmodule TestExUnit.Sample do
  def double(enumerable) do
    Enum.map(enumerable, fn n -> n * 2 end)
  end
end

defmodule TestExUnit do
  use ExUnit.Case

  test "skip test has no block"

  test "q.23-3-1" do
    assert(TestExUnit.Sample.double([1, 2, 3]) == [2, 4, 6])
    assert(TestExUnit.Sample.double(1..3) == [2, 4, 6])
  end
end


