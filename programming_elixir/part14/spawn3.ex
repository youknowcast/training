defmodule Spawn3 do
  def greet do
    receive do
      {sender, msg} ->
        send sender, { :ok, "Hello, #{msg}" }
      # checking forever
      greet()
    end
  end
end

pid = spawn(Spawn3, :greet, [])
send pid, {self(), "world"}
receive do
  {:ok, message} ->
    IO.puts message
end

send pid, {self(), "kermit"}
receive do
  {:ok, message} ->
    IO.puts message
after 500 ->
    IO.puts "The greeter has gone away"
end

