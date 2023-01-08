defmodule Sequence.ServerTest do
  use ExUnit.Case
  doctest Sequence.Server

  test "server works" do
    {:ok, pid} = GenServer.start_link(Sequence.Server, 1)

    assert(GenServer.call(pid, :next_number) == 1)
    assert(GenServer.call(pid, :next_number) == 2)
  end

  describe ":set_number" do
    test "works" do
      {:ok, pid} = GenServer.start_link(Sequence.Server, 1)

      assert(GenServer.call(pid, :next_number) == 1)

      assert(GenServer.call(pid, {:set_number, 999}) == 999)
      assert(GenServer.call(pid, :next_number) == 999)
      assert(GenServer.call(pid, :next_number) == 1000)
    end

    test "clash with non-integer" do
      {:ok, pid} = GenServer.start_link(Sequence.Server, 1)

      assert(GenServer.call(pid, {:set_number, "hoge"}) == :invalid_number)
    end
  end
end
