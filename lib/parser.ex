defmodule Toille.Parser do

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
	def print_with_color( line, color ), do: [color, line] |> Bunt.ANSI.format |> IO.puts

	def display_tasks( tasks ) do
		print_with_color( " \n Available Tasks: ", :color197 )
		for payload <- tasks do
			{ _, task } = payload
			print_with_color( " 📌 #{task["status"]} Task<#{task["id"]}> #{task["title"]}", :color219 )
		end
	end

end
