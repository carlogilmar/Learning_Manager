defmodule Etoile.Cli.CliTimeline do

  alias Etoile.Parser
  alias Etoile.CalendarUtil
  alias Etoile.TimelineManager
  alias Etoile.TagManager
  alias Etoile.Cli.CliWorker

  def cli( user ), do: execute_command( user )

  def display_menu( user ) do
    CalendarUtil.print_current_day()
    TimelineManager.find_active_timeline( user["username"] )
		Parser.print_with_color "-----------------------------------------", :color87
    Parser.print_with_color " 1. Add current week as timeline [ok]        ", :color228
		Parser.print_with_color " 2. List timelines stored [ok]               ", :color228
		Parser.print_with_color " 3. Operate current timeline                ", :color228
		Parser.print_with_color " 4. Show a timeline                      ", :color228
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color " (5) Add label (6) Show labels   [ok]        ", :color228
		Parser.print_with_color " (7) Add places (8) Show places     [ok]     ", :color228
		Parser.print_with_color "-----------------------------------------", :color87
    Parser.print_with_color " (h) Show menu (q) Quit app", :color87
		cli( user )
  end

  def execute_command( user ) do
    receive_command
      |> execute( user )
  end

  def receive_command(), do: IO.gets("\n 🌟 >>> ") |> Parser.parse_command()
  def receive_command( prompt ), do: IO.gets("  #{prompt}") |> Parser.parse_command()

	def execute( cmd, user ) do
    case cmd do
      "1" ->
        TimelineManager.create( user["username"] )
        cli(user)
      "2" ->
        TimelineManager.get_all_from_user( user["username"] )
        cli(user)
      "3" ->
        CliWorker.display_operate_current_timeline( user )
      "4" ->
        cli(user)
      "5" ->
        display_label_msg()
          |> TagManager.add_label( user["username"] )
        cli(user)
      "6" ->
        TagManager.list_labels( user["username"] )
        cli(user)
      "7" ->
        display_place_msg()
          |> TagManager.add_place( user["username"] )
        cli(user)
      "8" ->
        TagManager.list_places( user["username"] )
        cli(user)
      "h" ->
        display_menu(user)
			"q" ->
				Parser.print_with_color " \n Learning Manager Goodbye! \n", :color201
      _ ->
    		cli(user)
    end
	end

  defp display_label_msg(), do: receive_command( " Label name >>> " )
  defp display_place_msg(), do: receive_command( " Place name >>> " )

end
