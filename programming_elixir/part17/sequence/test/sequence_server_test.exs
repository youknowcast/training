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

    test "with non-integer value" do
      {:ok, pid} = GenServer.start_link(Sequence.Server, 1)

      assert(GenServer.call(pid, {:set_number, "hoge"}) == :invalid_number)
      assert(GenServer.call(pid, :next_number) == 1)
    end
  end

  describe ":increment_number" do
    test "works" do
      {:ok, pid} = GenServer.start_link(Sequence.Server, 1)

      assert(GenServer.cast(pid, {:increment_number, 200}) == :ok)
      assert(GenServer.call(pid, :next_number) == 201)
      assert(GenServer.call(pid, :next_number) == 202)
    end

    test "witrh non-integer value" do
      {:ok, pid} = GenServer.start_link(Sequence.Server, 1)

      assert(GenServer.cast(pid, {:increment_number, "hoge"}) == :ok)
      assert(GenServer.call(pid, :next_number) == 1)
    end
  end
end
