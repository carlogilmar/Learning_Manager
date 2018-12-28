defmodule Etoile.Cli.CliTimeline do

  alias Etoile.Parser
  alias Etoile.CalendarUtil
  alias Etoile.TimelineManager
  alias Etoile.TagManager
  alias Etoile.Cli.CliWorker

  def cli( user ), do: execute_command( user )

  def display_menu( user ) do
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color " 🏠 HOME ", :color75
		Parser.print_with_color " Welcome #{user["username"]}", :color51
    CalendarUtil.print_current_day()
    TimelineManager.print_active_timeline( user["username"] )
		Parser.print_with_color "-----------------------------------------", :color87
    active = TimelineManager.find_active_timeline( user["username"] )
    case active do
      [] ->
        Parser.print_with_color " (begin) Add current week as timeline ", :color228
      _active ->
        Parser.print_with_color " (start) Go to timeline home 🔧 ", :color228
    end
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color " (timelines) List timelines stored ", :color228
		Parser.print_with_color " Labels (new_label) New (show_labels) List ", :color228
		Parser.print_with_color " Places (new_place) New (show_places) List ", :color228
		Parser.print_with_color "-----------------------------------------", :color87
    Parser.print_with_color " (h) Help (q) Quit ", :color87
		cli( user )
  end

  def execute_command( user ) do
    receive_command
      |> execute( user )
  end

  def receive_command(), do: IO.gets("\n 🏠 >>> ") |> Parser.parse_command()
  def receive_command( prompt ), do: IO.gets("  #{prompt}") |> Parser.parse_command()

	def execute( cmd, user ) do
    cmd = String.split( cmd, " " )
    case cmd do
      ["start"] ->
        CliWorker.display_operate_current_timeline( user )
      ["begin"] ->
        TimelineManager.create( user["username"] )
        display_menu(user)
      ["timelines"] ->
        TimelineManager.get_all_from_user( user["username"] )
        cli(user)
      ["new_label", label] ->
        TagManager.add_label( label, user["username"] )
        cli(user)
      ["show_labels"] ->
        TagManager.list_labels( user["username"] )
        cli(user)
      ["new_place", place] ->
        TagManager.add_place( place, user["username"] )
        cli(user)
      ["show_places"] ->
        TagManager.list_places( user["username"] )
        cli(user)
      ["h"] ->
        display_menu(user)
			["q"] ->
				Parser.print_with_color " \n Learning Manager Goodbye! \n", :color201
      _ ->
    		cli(user)
    end
	end

end
