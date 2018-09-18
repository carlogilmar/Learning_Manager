defmodule Etoile.Parser do

  def get_uuid() do
    uuid = UUID.uuid1()
    << id1::8, id2::8, id3::8, id4::8, id5::8, id6::8, _::30*8 >> = uuid
    <<id1>> <> <<id2>> <> <<id3>> <> <<id4>> <> <<id5>> <> <<id6>>
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
    done |> print( :color198, "😎")
	end

  def print( line_with_color ), do: line_with_color |> Bunt.ANSI.format |> IO.puts

  def print( tasks, color, emoji ) do
		for task <- tasks do
      [:color172, " #{emoji} <#{task["id"]}> ", color, "  #{task["status"]}  #{task["title"]}"] |> print()
		end
  end

end
