defmodule Etoile.Cli.CliTimeline do

  alias Etoile.Parser
	alias Etoile.FirebaseManager
  alias Etoile.TaskManager
  alias Etoile.ProjectManager
  alias Etoile.CalendarUtil
  alias Etoile.TimelineManager

  def cli( user ), do: receive_command( user )

  def display_menu( user ) do
    CalendarUtil.print_current_day()
    TimelineManager.find_active_timeline( user["username"] )
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color " 1. Add current week as timeline         ", :color228
		Parser.print_with_color " 2. List timelines stored                ", :color228
		Parser.print_with_color " 3. Show timeline                        ", :color228
		Parser.print_with_color "-----------------------------------------", :color87
    Parser.print_with_color " (q) Quit app", :color87
		cli( user )
  end

  def receive_command( user ) do
    IO.gets("\n 🌟 >>> ")
      |> Parser.parse_command()
      |> execute( user )
  end

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
      "h" ->
        display_menu(user)
			"q" ->
				Parser.print_with_color " \n Learning Manager Goodbye!. \n", :color201
      _ ->
    		cli(user)
    end
	end

end
