defmodule Sequence.Server do
  use GenServer
  
  def init(initial_number) do
    {:ok, initial_number}
  end

  def handle_call(:next_number, _from, current_number) do
    {:reply, current_number, current_number + 1}
  end

  def handle_call({:set_number, new_number}, _, _) when is_number(new_number) do
    {:reply, new_number, new_number}
  end
  def handle_call({:set_number, _}, _, current_number) do
    {:reply, :invalid_number, current_number}
  end

  def handle_cast({:increment_number, delta}, current_number) when is_number(delta) do
    {:noreply, current_number + delta}
  end
  def handle_cast({:increment_number, _}, current_number) do
    {:noreply, current_number}
  end
end
