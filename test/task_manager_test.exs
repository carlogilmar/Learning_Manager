defmodule Etoile.TaskManagerTest do

  use ExUnit.Case
  alias Etoile.TaskManager

  test "Filter task list by status" do
    tasks = [
      %{ "title" => "titulo1", "status" => "TODO" },
      %{ "title" => "titulo2", "status" => "DOING" },
      %{ "title" => "titulo3", "status" => "DONE" },
      %{ "title" => "titulo4", "status" => "TODO" },
      %{ "title" => "titulo5", "status" => "DONE" },
      %{ "title" => "titulo6", "status" => "DONE" }
    ]
    {todos, doing, done} = TaskManager.filter_by_status( tasks )
    [todo_task, _] = todos
    [ doing_task ] = doing
    [ done_task , _, _] = done
    assert todo_task["title"] == "titulo1"
    assert doing_task["title"] == "titulo2"
    assert done_task["title"] == "titulo3"
  end
end
