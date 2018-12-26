defmodule Etoile.CliTimeline do

  alias Etoile.Parser
	alias Etoile.FirebaseManager
  alias Etoile.TaskManager
  alias Etoile.ProjectManager

  def cli( user ), do: receive_command( user )

  def display_menu( user ) do
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

  #iex(3)> {:ok, date} = Calendar.DateTime.now("America/Mexico_City")
  #{:ok, #DateTime<2018-12-25 23:37:26.115723-06:00 CST America/Mexico_City>}
  #iex(4)> date
  ##DateTime<2018-12-25 23:37:26.115723-06:00 CST America/Mexico_City>
  #iex(5)> Calendar.Date.week_number date
  #{2018, 52}
  #Calendar.Date.dates_for_week_number {2018, 52}

end
