defmodule Etoile.Parser do

  alias Etoile.Calendar

  def get_uuid() do
    uuid = UUID.uuid1()
    << id1::8, id2::8, id3::8, _::33*8 >> = uuid
    <<id1>> <> <<id2>> <> <<id3>>
  end

  def parse_command( cmd ) do
    [command, _] = String.split( cmd, "\n")
    command
  end

	@doc"""
		iex> Parser.print_with_color "que onda!", :color253
		For show colors visit: https://github.com/rrrene/bunt
	"""
	def print_with_color( line, color ), do: [color, line] |> print

  def print_tasks( { todos, doing, done } ) do
		print_with_color( " \n Available Tasks: ", :color197 )
    todos |> print( :color226, "📌" )
    doing |> print( :color87, "⭐️" )
    done |> print( {:color198, "😎"} )
	end

  def print( line_with_color ), do: line_with_color |> Bunt.ANSI.format |> IO.puts

  def print( tasks, { color, emoji} ) do
    for task <- tasks do
      duration = Calendar.get_duration( task["end_time"], task["start_time"])
      minutes = Float.round( duration, 2)
      [:color172, " #{emoji} <#{task["id"]}>",
       :color75, " #{task["day"]}/#{task["month"]}",
       color, " #{task["status"]}",
       :color172, " <#{task["user"]}>",
       color, " :: #{task["title"]} ::",
       :color165, " Finished in #{minutes} min."]
       |> print()
		end
  end

  def print( tasks, color, emoji ) do
		for task <- tasks do
      [:color172, " #{emoji} <#{task["id"]}>",
       :color75, " #{task["day"]}/#{task["month"]}",
       :color172, " <#{task["user"]}>",
       color, " #{task["status"]} :: #{task["title"]} ::"]
       |> print()
		end
  end

  def show_wip( [] ), do: print_with_color( "\n There isn't a current task doing. 😳 ", :color198 )
  def show_wip( doing_tasks ) do
    for task <- doing_tasks do
      [:color83, " \n .::: 💪 WORK IN PROGRESS :: <#{task["id"]}> #{task["title"]} :::."] |> print()
    end
  end

  def show_todo( [] ), do: print_with_color( "\n There isn't a current task doing. 😬 ", :color198 )
  def show_todo( todo_tasks )do
    for task <- todo_tasks do
      [:color83, "\n .::: 🤯 TODO TASKS :: <#{task["id"]}> #{task["title"]} :::."] |> print()
    end
  end

end
