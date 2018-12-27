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
    Parser.print_with_color " (a) Add task ", :color213
    Parser.print_with_color " (l) Show tasks", :color213
    Parser.print_with_color " (wip) Show work in progress", :color213
    Parser.print_with_color " (done) ", :color213
    Parser.print_with_color " (done) Show tasks done", :color213
    Parser.print_with_color " (u) Update task (d) delete task ", :color213
    Parser.print_with_color " (h) Help (q) Back", :color87
    execute_command( user )
  end

  def execute( cmd, user ) do
    case cmd do
			"a" ->
				execute_add_task(user["username"])
    		cli(user)
			"l" ->
				execute_show_tasks(user["username"])
    		cli(user)
      #"wip" ->
      #  get_wip_tasks()
      #  cli()
      #"todo" ->
      #  show_todo_tasks()
      #  cli()
      #"u" ->
      #  update_task()
      #  cli()
      #"d" ->
      #  remove_task()
      #  cli()
      #"done" ->
      #  add_done_task()
      #  cli()
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

end
