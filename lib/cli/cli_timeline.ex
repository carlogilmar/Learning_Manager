defmodule Etoile.Cli.CliTimeline do

  alias Etoile.Parser
  alias Etoile.CalendarUtil
  alias Etoile.TimelineManager
  alias Etoile.TagManager

  def cli( user ), do: execute_command( user )

  def display_menu( user ) do
    CalendarUtil.print_current_day()
    TimelineManager.find_active_timeline( user["username"] )
		Parser.print_with_color "-----------------------------------------", :color87
    Parser.print_with_color " 1. Add current week as timeline [ok]        ", :color228
		Parser.print_with_color " 2. List timelines stored [ok]               ", :color228
		Parser.print_with_color " 3. Show current timeline                ", :color228
		Parser.print_with_color " 4. Show a timeline                      ", :color228
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color " (5) Add label (6) Show labels           ", :color228
		Parser.print_with_color " (7) Add places (8) Show places          ", :color228
		Parser.print_with_color "-----------------------------------------", :color87
    Parser.print_with_color " (h) Show menu (q) Quit app", :color87
		cli( user )
  end

  def execute_command( user ) do
    receive_command
      |> execute( user )
  end

  def receive_command(), do: IO.gets("\n 🌟 >>> ") |> Parser.parse_command()

	def execute( cmd, user ) do
    case cmd do
      "1" ->
        TimelineManager.create( user["username"] )
        cli(user)
      "2" ->
        TimelineManager.get_all_from_user( user["username"] )
        cli(user)
      "3" ->
        cli(user)
      "4" ->
        cli(user)
      "5" ->
        TagManager.add_label( user["username"] )
        cli(user)
      "6" ->
        TagManager.list_labels( user["username"] )
        cli(user)
      "7" ->
        TagManager.add_place( user["username"] )
        cli(user)
      "8" ->
        TagManager.list_places( user["username"] )
        cli(user)
      "h" ->
        display_menu(user)
			"q" ->
				Parser.print_with_color " \n Learning Manager Goodbye!. \n", :color201
      _ ->
    		cli(user)
    end
	end

end
