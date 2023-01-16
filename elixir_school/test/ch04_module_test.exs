defmodule Ch04ModuleTest do
  use ExUnit.Case

  test "create defstruct" do
    user = %ElixirSchool.User{}
    assert(user.name == "Sean")

    user2 = %ElixirSchool.User{name: "John"}
    assert(user2.name == "John")

    user3 = %ElixirSchool.User{name: "Steve", roles: [:manager]}
    assert(user3.name == "Steve" and user3.roles == [:manager])

    match_map? = fn s ->
      case s do
        %{name: name} -> name
        _ -> :not_match
      end
    end

    assert(match_map?.(user) == "Sean")

    updated_user = %{user | name: "Jean"}
    assert(updated_user.name == "Jean")
  end

  test "derive" do
    # @derive Inspect controls returning specific keys
    user = %ElixirSchool.User{age: 30}
    assert(user.age == 30)
    assert(inspect(user) |> String.match?(~r/age:/) == false)
  end
end
