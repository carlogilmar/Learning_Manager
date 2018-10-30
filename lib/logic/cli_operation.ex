defmodule Etoile.CliOperation do

  alias Etoile.Parser
	alias Etoile.FirebaseManager
  alias Etoile.TaskManager
  alias Etoile.ProjectManager

  def cli() do
    receive_command()
  end

  def show_menu() do
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color "            Learning Manager App 🌟 !", :color228
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color " (p) Show projects (ap) Create new project ", :color214
		Parser.print_with_color "-----------------------------------------", :color87
    Parser.print_with_color "(done) Add DONE task (wip) Show WIP (todo) Show TODO (web) Show web url", :color214
		Parser.print_with_color "-----------------------------------------", :color87
    Parser.print_with_color " (h) Menu help (q) Quit app", :color87
		cli()
  end

  def receive_command() do
    IO.gets("\n 🌟 >>> ")
      |> Parser.parse_command()
      |> execute()
  end

	def execute( cmd ) do
    case cmd do
      "projects" ->
        show_projects()
        cli()
      "create" ->
        add_project()
        cli()
      "h" ->
				show_menu()
			"a" ->
				execute_add_task()
    		cli()
			"l" ->
				execute_show_tasks()
    		cli()
      "wip" ->
        get_wip_task()
        cli()
      "todo" ->
        show_todo_tasks()
        cli()
      "u" ->
        update_task()
        cli()
      "d" ->
        remove_task()
        cli()
      "web" ->
				Parser.print_with_color " \n Le Etoile App 🌟 Visit the Ember Aoo: https://le-etoile.herokuapp.com/. \n", :color201
        cli()
      "done" ->
        add_done_task()
        cli()
			"q" ->
				Parser.print_with_color " \n Le Etoile App 🌟 Says: Goodbye!. \n", :color201
      _ ->
    		cli()
    end
	end

	def execute_add_task() do
    project = ProjectManager.choose_project()
    Parser.print_with_color " Project Selected: #{project["project_name"]}", :color201
  	title =
			IO.gets(" 🌟 Task Description >>> ")
      |> Parser.parse_command()
    TaskManager.create_task( title, project )
      |> FirebaseManager.add_task()
	end

  def execute_show_tasks() do
    project = ProjectManager.choose_project()
    Parser.print_with_color "Project Selected: #{project["project_name"]}", :color201
    FirebaseManager.show_tasks
      |> TaskManager.filter_by_status( project["project_id"] )
      |> Parser.print_tasks
  end

  def get_wip_task() do
    FirebaseManager.show_tasks
      |> TaskManager.get_wip
      |> Parser.show_wip
  end

	def update_task() do
  	task_id =
			IO.gets("\n Task ID >>> ")
      |> Parser.parse_command()
    show_update_menu()
    next_status =
			IO.gets("\n Status >>> ")
      |> Parser.parse_command()
      |> get_next_status()
    FirebaseManager.update_task( task_id, next_status )
  end

  def remove_task() do
    IO.gets("\n Task ID >>> ")
      |> Parser.parse_command()
      |> FirebaseManager.delete_task()
  end

  def get_next_status( status ) do
    case status do
      "1" -> "TODO"
      "2" -> "DOING"
      "3" -> "DONE"
      _ ->
				Parser.print_with_color " \n Status invalid! \n", :color198
    end
  end

  def show_update_menu() do
		Parser.print_with_color "-----------", :color214
		Parser.print_with_color " 1) TODO ", :color87
		Parser.print_with_color " 2) DOING ", :color87
		Parser.print_with_color " 3) DONE ", :color87
		Parser.print_with_color "-----------", :color214
  end

  def show_todo_tasks() do
    FirebaseManager.show_tasks
    |> TaskManager.get_todo_tasks
    |> Parser.show_todo
  end

  def add_done_task() do
  	title =
			IO.gets("\n ✅ Task Done >>> " )
      |> Parser.parse_command()
    {duration, _} =
			IO.gets("\n ⏳ Task Duration (min) >>> " )
      |> Parser.parse_command()
      |> Integer.parse()
    TaskManager.add_done_task( title, duration )
      |> FirebaseManager.add_task()
  end

  def show_projects() do
    FirebaseManager.show_projects
    |> Parser.print_projects()
		Parser.print_with_color "(l) List tasks (a) Add task (u) Update task (d) Delete tasks", :color214
  end

  def add_project() do
    IO.gets(" 📁  New Project ::: >>>  " )
      |> Parser.parse_command()
      |> ProjectManager.add_project()
      |> FirebaseManager.add_project()
    Parser.print_with_color " (a) Add task (l) List tasks (u) Update task (d) Delete task", :color214
  end

end
