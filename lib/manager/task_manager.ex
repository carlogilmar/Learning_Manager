defmodule Etoile.TaskManager do

  alias Etoile.Calendar
  alias Etoile.Parser

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

  def get_wip( tasks )do
    get_status( tasks, @doing )
  end

  def get_status( tasks, status) do
    Enum.filter( tasks, fn task -> task["status"] == status end )
  end

  def create_task( title ) do
    { day, _, year, month } = Calendar.get_current_day
    id = Parser.get_uuid()
    %{ id: id, title: title, status: @todo, day: day, month: month, year: year }
  end

end
