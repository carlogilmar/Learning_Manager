defmodule Etoile.Cli.CliTimeline do

  alias Etoile.Parser
  alias Etoile.CalendarUtil
  alias Etoile.TimelineManager
  alias Etoile.TagManager
  alias Etoile.Cli.CliWorker

  def cli( user ), do: execute_command( user )

  def display_menu( user ) do
		Parser.print_with_color " 🏠 HOME ", :color75
		Parser.print_with_color " Welcome #{user["username"]}", :color51
    CalendarUtil.print_current_day()
    TimelineManager.print_active_timeline( user["username"] )
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color " 1. Start 🔧 ", :color228
		Parser.print_with_color "-----------------------------------------", :color87
    Parser.print_with_color " 2. Add current week as timeline ", :color228
		Parser.print_with_color " 3. List timelines stored ", :color228
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color " Labels (5) New (6) List ", :color228
		Parser.print_with_color " Places (7) New (8) List ", :color228
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
    case cmd do
      "1" ->
        CliWorker.display_operate_current_timeline( user )
      "2" ->
        TimelineManager.create( user["username"] )
        cli(user)
      "3" ->
        TimelineManager.get_all_from_user( user["username"] )
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
