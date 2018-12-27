defmodule Etoile.TaskManager do

  import Enum, only: [filter: 2]
  alias Etoile.Calendar
  alias Etoile.Parser
  alias Etoile.ProjectManager
  alias Etoile.RequestManager
  alias Etoile.TimelineManager
  alias Etoile.CalendarUtil

  @todo "TODO"
  @doing "DOING"
  @done "DONE"

  def create_task( title, label, user ) do
    [{_id, timeline}] = TimelineManager.find_active_timeline( user )
    {_year, _month, day, _week} = CalendarUtil.get_current_date()
    id = Parser.get_uuid()
    task = %{ id: id, title: title, status: @todo, day: day, week: timeline["week"], year: timeline["year"], user: user, label: label }
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
     Parser.print_with_color " #{task["id"]} #{task["status"]} <#{task["label"]}> #{task["title"]}", color
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

  ##### Deprecated ================================================================00

  def get_wip( tasks )do
    get_status( tasks, @doing )
  end



  def get_current_user() do
    { user, _} = System.cmd("whoami", [])
    Parser.parse_command( user )
  end

  def find_task( tasks, task_id, status ) do
    Enum.filter( tasks, fn task -> task["id"] == task_id end ) |> prepare_for_update( status )
  end

  def prepare_for_update( [], _ ), do: Parser.print_with_color " \n Invalid Task ID", :color198
  def prepare_for_update( [ task ], status ) do
    firebase_uuid = task["firebase_uuid"]
    task_updated = get_updated_task( task, status )
    { firebase_uuid, task_updated }
  end

  def get_updated_task( task, "DOING" ) do
    #Map.put( task, "status", @doing)
    # todos rser.print_with_color " \n Invalid Task ID", :color198 |> Map.delete("firebase_uuid")
    #  |> Map.put("start_time", :os.system_time(:millisecond) )
  end

  def get_updated_task( task, "DONE" ) do
    Map.put( task, "status", @done)
      |> Map.delete("firebase_uuid")
      |> Map.put("end_time", :os.system_time(:millisecond) )
  end

  def get_updated_task( task, _ ) do
    Map.put( task, "status", @todo)
      |> Map.delete("firebase_uuid")
      |> Map.delete("start_time")
      |> Map.delete("end_time")
  end

  def add_done_task( title, duration) do
    { day, _, year, month } = Calendar.get_current_day
    id = Parser.get_uuid()
    current_user = get_current_user()
    minutes = (duration * 60) * 1000
    end_time = :os.system_time(:millisecond)
    start_time = end_time - minutes
    %{ id: id, title: title, status: @done, day: day, month: month, year: year, user: current_user, start_time: start_time, end_time: end_time}
  end

  def get_todo_tasks( tasks ) do
    filter( tasks, fn task -> task["status"] == "TODO" end )
  end

  def add_project( project_name ) do
    id = Parser.get_uuid()
    %{ project_id: id, project_name: project_name }
  end

end
