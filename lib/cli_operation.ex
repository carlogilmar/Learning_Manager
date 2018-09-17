defmodule Toille.CliOperation do

  alias Toille.Parser

  def cli() do
    show_menu()
    receive_command()
  end

  def show_menu() do
		Parser.print_with_color "---------------------", :color87
		Parser.print_with_color "   Le Toille App 🌟 !", :color228
		Parser.print_with_color "---------------------", :color87
  end

  def receive_command() do
    IO.gets(" 🌟 How Can I Help u ? >>> ")
      |> Parser.parse_command()
      |> execute()
  end

  def show_users() do
    response = HTTPoison.get! "https://gameofchats-db1b4.firebaseio.com/users.json"
    body = Poison.decode!(response.body)
    IO.inspect body
  end

  def execute("sigue") do
    IO.puts " Siguiendo!!! Hola soy Le Toille! 🌟 "
    cli()
  end

  def execute("users") do
    IO.puts " Le Toille! 🌟 says: Showing users ..."
    show_users()
    cli()
  end

  def execute("quit") do
    IO.puts " 🌟 Le toille says: Goodbye!!"
  end

  def execute(_) do
		Parser.print_with_color " \n Le Toille App 🌟 Says: I can't understand you.", :color198
    cli()
  end
end
