defmodule Etoile.CliOperation do

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
		Parser.print_with_color " - menu >> Show this menu ", :color214
		Parser.print_with_color " - show >> Show all tasks  ", :color214
		Parser.print_with_color " - add >> Add a new task  ", :color214
		#Parser.print_with_color " - wip >> Show the current task in progress ", :color214
		#Parser.print_with_color " - finish >> End the current task ", :color214
		#Parser.print_with_color " - edit >> Rename a task ", :color214
		#Parser.print_with_color " - remove >> Remove a task ", :color214
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
      "m" ->
				show_menu()
			"at" ->
				execute_add_task()
				Parser.print_with_color " \n 😚 Task added.", :color46
    		cli()
			"lt" ->
				execute_show_tasks()
    		cli()
			"quit" ->
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
		task =
			%{ id: Parser.get_uuid(),
				 title: title,
				 date_created: :os.system_time(:milli_seconds),
				 status: "CREATED" } |> FirebaseManager.add_task
	end

  def execute_show_tasks() do
    FirebaseManager.show_tasks
      |> TaskManager.filter_by_status
      |> Parser.print_tasks
  end
end
