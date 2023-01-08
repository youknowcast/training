defmodule Sequence.ServerTest do
  use ExUnit.Case
  doctest Sequence.Server

  alias Sequence.Server

  test "server works" do
    {:ok, _} = Server.start_link(1)

    assert(Server.next_number() == 1)
    assert(Server.next_number() == 2)
  end

  describe ":set_number" do
    test "works" do
      {:ok, _} = Server.start_link(1)

      assert(Server.next_number() == 1)

      assert(Server.set_number(999) == 999)
      assert(Server.next_number() == 999)
      assert(Server.next_number() == 1000)
    end

    test "with non-integer value" do
      {:ok, _} = Server.start_link(1)

      assert(Server.set_number("hoge") == :invalid_number)
      assert(Server.next_number() == 1)
    end
  end

  describe ":increment_number" do
    test "works" do
      {:ok, _} = Server.start_link(1)

      assert(Server.increment_number(200) == :ok)
      assert(Server.next_number() == 201)
      assert(Server.next_number() == 202)
    end

    test "witrh non-integer value" do
      {:ok, _} = Server.start_link(1)

      assert(Server.increment_number("hoge") == :ok)
      assert(Server.next_number() == 1)
    end
  end
end
