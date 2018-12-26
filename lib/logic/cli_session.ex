defmodule Etoile.CliSession do

  alias Etoile.Parser

  def cli() do
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color "   LEARNING MANAGER REGISTER             ", :color228
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color " Write your username: < 1 word > ", :color228
    IO.gets("\n 🌟 >>> ")
      |> Parser.parse_command()
      |> register_username()

  end

  def register_username( username ) do
		Parser.print_with_color "   Sign up new user... wait...           ", :color228
    user = %{ username: username }
    user_encoded = user  |> Poison.encode!
    {:ok, _payload} = HTTPoison.post "https://gameofchats-db1b4.firebaseio.com/users.json", user_encoded
		Parser.print_with_color "-----------------------------------------", :color87
		Parser.print_with_color "   User Registered.                      ", :color228
		Parser.print_with_color "   Please login with your username:      ", :color228
		Parser.print_with_color "   > learning_manager --user #{username} ", :color228
		Parser.print_with_color "           Thanks!                       ", :color228
  end

end
