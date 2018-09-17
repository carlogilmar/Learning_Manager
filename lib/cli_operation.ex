defmodule Toille.CliOperation do

  alias Toille.Parser
	alias Toille.FirebaseManager

  def cli() do
    receive_command()
  end

  def show_menu() do
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color "            Le Toille App 🌟 !", :color228
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
    IO.gets("\n 🌟 Le Toille App: How can I help you ? >>> ")
      |> Parser.parse_command()
      |> execute()
  end

	def execute( cmd ) do
    case cmd do
      "menu" ->
				show_menu()
			"add" ->
				execute_add_task()
				Parser.print_with_color " \n 😚 Task added.", :color46
    		cli()
			"show" ->
				execute_show_tasks()
    		cli()
			"quit" ->
				Parser.print_with_color " \n Le Toille App 🌟 Says: Goodbye!. \n", :color201
      _ ->
				Parser.print_with_color " \n Le Toille App 🌟 Says: I can't understand you. \n", :color198
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

	def execute_show_tasks(), do: FirebaseManager.show_tasks

end
