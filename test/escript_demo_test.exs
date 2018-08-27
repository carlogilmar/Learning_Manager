defmodule EscriptDemoTest do
  use ExUnit.Case
  doctest EscriptDemo

  test "greets the world" do
    assert EscriptDemo.hello() == :world
  end
end
