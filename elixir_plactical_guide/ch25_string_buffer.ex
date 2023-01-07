defmodule StringBuffer do
  use Agent

  def start_link(initial_state) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def append(str) do
    Agent.update(__MODULE__, fn state -> state <> str end)
  end

  def get_value do
    Agent.get(__MODULE__, fn state -> state end)
  end
end

#StringBuffer.start_link("")
#StringBuffer.append("A")
#StringBuffer.append("B")
#StringBuffer.append("C")
#StringBuffer.append("D")
#
#IO.inspect(StringBuffer.get_value())

ExUnit.start(exclude: :not_implemented)

defmodule TestStringBuffer do
  use ExUnit.Case
  import StringBuffer

  defp initial_state(), do: ""

  setup do
    start_link(initial_state())

    %{}
  end

  test "returns state" do
    assert(get_value() == "")
  end

  test "returns updated state" do
    append("hoge")
    assert(get_value() == "hoge")

    append("huga")
    assert(get_value() == "hogehuga")
  end

  test "multi run start_link" do
    {:error, {:already_started, pid}} = start_link("aa")
    assert(is_pid(pid))
  end
end

