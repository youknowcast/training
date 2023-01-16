defmodule ElixirSchool.User do
  @derive {Inspect, except: [:age]}
  defstruct name: "Sean", roles: [], age: 0
end
