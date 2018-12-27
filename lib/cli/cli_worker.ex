defmodule Etoile.Cli.CliWorker do

  alias Etoile.Cli.CliTimeline
  alias Etoile.TagManager
  alias Etoile.NoteManager
  alias Etoile.BudgetManager
	alias Etoile.FirebaseManager
  alias Etoile.TaskManager
  alias Etoile.Parser
  alias Etoile.CalendarUtil

  def cli( user ) do
    execute_command( user )
  end

  def execute_command( user ) do
    receive_command
      |> execute( user )
  end

  def receive_command(), do: IO.gets("\n 🔧 >> ") |> Parser.parse_command()
  def receive_command( prompt ), do: IO.gets("  #{prompt}") |> Parser.parse_command()

  def display_operate_current_timeline( user ) do
    Parser.print_with_color "\n 🔧 Timeline ", :color199
    CalendarUtil.print_current_day()
    Parser.print_with_color " - - - - - - - - - - - -  - ", :color51
    Parser.print_with_color " Notes (1) New (2) List ", :color213
    Parser.print_with_color " Budgets (3) New (4) List ", :color213
    Parser.print_with_color " - - - - - - - - - - - -  - ", :color51
    Parser.print_with_color " - Add task (new)", :color213
    Parser.print_with_color " - Show tasks (all) (todo) (wip) (done) ", :color213
    Parser.print_with_color " (u) Update task (d) delete task ", :color213
    Parser.print_with_color " - - - - - - - - - - - -  - ", :color51
    Parser.print_with_color " (h) Help (q) Back", :color87
    execute_command( user )
  end

  def execute( cmd, user ) do
    case cmd do
			"new" ->
        TagManager.list_labels( user["username"] )
				execute_add_task(user["username"])
    		cli(user)
			"all" ->
				execute_show_tasks(user["username"])
    		cli(user)
			"todo" ->
				execute_show_todo(user["username"])
    		cli(user)
			"wip" ->
				execute_show_wip(user["username"])
    		cli(user)
      "done" ->
				execute_show_done(user["username"])
    		cli(user)
      "u" ->
        update_task(user["username"])
        cli(user)
      "d" ->
        remove_task(user["username"])
        cli(user)
      "1" ->
        TagManager.list_labels( user["username"] )
        note = receive_command(" 🔖 >> ")
        label = receive_command(" Choose label >> ")
        Parser.print_with_color "  - - - - - - - - - - - -  - ", :color52
        NoteManager.save_note( user["username"], note, label)
        cli( user )
      "2" ->
        NoteManager.list_notes( user["username"] )
        cli( user )
      "3" ->
        budget = receive_command(" 💵 >> ")
        BudgetManager.add_budget( budget, user["username"] )
        Parser.print_with_color "  - - - - - - - - - - - -  - ", :color52
        cli( user )
      "4" ->
        BudgetManager.list_budgets( user["username"] )
        cli( user )
      "h" ->
        display_operate_current_timeline( user )
      "q" ->
        CliTimeline.cli( user )
      _ ->
        cli( user )
    end
  end

	def execute_add_task( user ) do
    label = receive_command(" Label >> ")
  	title = IO.gets(" 🌟 Task Description >>> ") |> Parser.parse_command()
    TaskManager.create_task( title, label, user )
	end

  def execute_show_tasks( user ), do: TaskManager.display_tasks_per_status( user )
  def execute_show_todo( user ), do: TaskManager.display_tasks_per_status( user, "TODO" )
  def execute_show_wip( user ), do: TaskManager.display_tasks_per_status( user, "DOING" )
  def execute_show_done( user ), do: TaskManager.display_tasks_per_status( user, "DONE" )

  def update_task( user ) do
  	task_id =
			IO.gets("\n Task ID >>> ")
      |> Parser.parse_command()
    show_update_menu()
    next_status =
			IO.gets("\n Status >>> ")
      |> Parser.parse_command()
      |> get_next_status()
    TaskManager.update_task_status( task_id, next_status )
  end

  def show_update_menu() do
		Parser.print_with_color " Update task: Choose next status ", :color214
		Parser.print_with_color "-----------", :color214
		Parser.print_with_color " 1) TODO 2) DOING 3) DONE ", :color87
		Parser.print_with_color "-----------", :color214
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

  def remove_task( user ) do
  	task_id =
			IO.gets("\n Task ID >>> ")
      |> Parser.parse_command()
    TaskManager.remove_task( task_id )
  end
end
