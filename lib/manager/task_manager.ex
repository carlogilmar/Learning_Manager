defmodule Etoile.TaskManager do

  alias Etoile.Parser
  alias Etoile.RequestManager
  alias Etoile.TimelineManager
  alias Etoile.CalendarUtil

  @todo "TODO"
  @doing "DOING"
  @done "DONE"

  def create_task( title, label, place, user ) do
    [{_id, timeline}] = TimelineManager.find_active_timeline( user )
    {_year, _month, day, _week} = CalendarUtil.get_current_date()
    id = Parser.get_uuid()
    task = %{ id: id, title: title, status: @todo, day: day, week: timeline["week"], year: timeline["year"], user: user, label: label, place: place }
    RequestManager.post("/tasks.json", task)
  end

  def list_tasks_per_status( user ) do
    [{_id, timeline}] = TimelineManager.find_active_timeline( user )
    tasks = RequestManager.get("/tasks.json")
    user_tasks = Enum.filter( tasks, fn {_id, task} ->
                                                      task["user"] == user and
                                                      task["week"] == timeline["week"] and
                                                      task["year"] == timeline["year"] end)
    todos = get_status( user_tasks, @todo )
    doing = get_status( user_tasks, @doing )
    done = get_status( user_tasks, @done )
    { todos, doing, done }
  end

  def get_status( tasks, status), do: Enum.filter( tasks, fn {_id, task} -> task["status"] == status end )

  def display_tasks_per_status( user ) do
    { todos, doing, done } = list_tasks_per_status( user )
    display_task( todos, :color204 )
    display_task( doing, :color229 )
    display_task( done, :color158 )
  end

  def display_tasks_per_status( user, status ) do
    { todos, doing, done } = list_tasks_per_status( user )
    case status do
      "TODO" -> display_task( todos, :color204 )
      "DOING" -> display_task( doing, :color229 )
      "DONE" -> display_task( done, :color158 )
    end
  end

  defp display_task( tasks, color ) do
    Enum.each( tasks, fn {_id, task} ->
     Parser.print_with_color " #{task["id"]} #{task["status"]} <#{task["label"]}> <#{task["place"]}> #{task["title"]}", color
    end)
  end

  def update_task_status( task_id, next_status) do
    {id_in_api, task} = find_task( task_id )
    task = Map.put( task, "status", next_status )
    RequestManager.put( "/tasks/#{id_in_api}.json", task)
  end

  def remove_task( task_id ) do
    {id_in_api, _task} = find_task( task_id )
    RequestManager.delete("/tasks/#{id_in_api}.json")
  end

  def find_task( id ) do
    [task] =
      RequestManager.get("/tasks.json")
        |> Enum.filter( fn {_id, task} -> task["id"] == id end)
    task
  end

  def display_tasks_history( user, week, year ) do
    tasks = RequestManager.get("/tasks.json")
    user_tasks = Enum.filter( tasks, fn {_id, task} ->
                                                      task["user"] == user and
                                                      task["week"] == week and
                                                      task["year"] == year end)
    todos = get_status( user_tasks, @todo )
    doing = get_status( user_tasks, @doing )
    done = get_status( user_tasks, @done )
    display_task( todos, :color204 )
    display_task( doing, :color229 )
    display_task( done, :color158 )
  end

end
