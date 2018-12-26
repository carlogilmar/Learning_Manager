defmodule Etoile.Cli.CliTimeline do

  alias Etoile.Parser
	alias Etoile.FirebaseManager
  alias Etoile.TaskManager
  alias Etoile.ProjectManager
  alias Etoile.Util.Timeline

  def cli( user ), do: receive_command( user )

  def display_menu( user ) do
    Timeline.print_current_day()
    Timeline.print_current_week()
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color " 1. Add current week as timeline         ", :color228
		Parser.print_with_color " 2. List timelines stored                ", :color228
		Parser.print_with_color " 3. Show timeline                        ", :color228
		Parser.print_with_color "-----------------------------------------", :color87
    Parser.print_with_color " (h) Menu help (q) Quit app", :color87
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
        IO.puts "Add timeline"
        cli(user)
      "2" ->
        IO.puts "List timelines"
        cli(user)
      "3" ->
        IO.puts "Show timeline"
        cli(user)
			"q" ->
				Parser.print_with_color " \n Learning Manager Goodbye!. \n", :color201
      _ ->
    		cli(user)
    end
	end

end
