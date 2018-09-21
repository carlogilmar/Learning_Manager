defmodule Etoile.CliOperation do
  import Enum, only: [filter: 2]

  alias Etoile.Parser
	alias Etoile.FirebaseManager
  alias Etoile.TaskManager

  def cli() do
    receive_command()
  end

  def show_menu() do
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color "            Le Etoile App 🌟 !", :color228
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color " - h >> Show this menu ", :color50
		Parser.print_with_color " - a >> Add task  ", :color214
		Parser.print_with_color " - todo >> TODO tasks  ", :color214
		Parser.print_with_color " - l >> List tasks  ", :color214
    Parser.print_with_color " - wip >> List current task in doing  ", :color214
    Parser.print_with_color " - u >> Update a task  ", :color214
    Parser.print_with_color " - d >> Remove a task  ", :color214
    Parser.print_with_color " - q >> Quit Le Etoile App  ", :color161
    Parser.print_with_color " - web >> Show the web app url  ", :color161
		Parser.print_with_color "-----------------------------------------", :color87
		cli()
  end

  def receive_command() do
    IO.gets("\n 🌟 >>> ")
      |> Parser.parse_command()
      |> execute()
  end

	def execute( cmd ) do
    case cmd do
      "h" ->
				show_menu()
			"a" ->
				execute_add_task()
				Parser.print_with_color " \n 😚 Task added.", :color46
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
			"q" ->
				Parser.print_with_color " \n Le Etoile App 🌟 Says: Goodbye!. \n", :color201
      _ ->
				Parser.print_with_color " \n Le Etoile App 🌟 Says: I can't understand you. \n", :color198
    		cli()
    end
	end

	def execute_add_task() do
  	title =
			IO.gets("\n 🌟 Task Description >>> ")
      |> Parser.parse_command()
    FirebaseManager.add_task( title )
	end

  def execute_show_tasks() do
    FirebaseManager.show_tasks
      |> TaskManager.filter_by_status
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
    |> get_todo_tasks
    |> Parser.show_todo
  end

  def get_todo_tasks( tasks ) do
    filter( tasks, fn task -> task["status"] == "TODO" end )
  end

end
