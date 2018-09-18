defmodule Etoile.TaskManager do

  @todo "TODO"
  @doing "DOING"
  @done "DONE"

  # Status: TODO, DOING, DONE
  def filter_by_status( tasks ) do
    todos = get_status( tasks, @todo )
    doing = get_status( tasks, @doing )
    done = get_status( tasks, @done )
    { todos, doing, done }
  end

  def get_status( tasks, status) do
    Enum.filter( tasks, fn task -> task["status"] == status end )
  end

end
