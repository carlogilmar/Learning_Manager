defmodule EscriptDemo do

  def main(args) do
    IO.puts "hola a todos!!"
    IO.inspect args
    cli()
  end

  def show_users() do
    response = HTTPoison.get! "https://gameofchats-db1b4.firebaseio.com/users.json"
    body = Poison.decode!(response.body)
    IO.inspect body
  end

  def cli() do
    show_menu()
    receive_command()
  end

  def show_menu() do
    IO.puts "=============================="
    IO.puts ""
    IO.puts ""
    IO.puts "Hola! 🤖 Soy Le Toiller Learning Manager"
    IO.puts ""
    IO.puts ""
    IO.puts "=============================="
  end

  def receive_command() do
    cmd = IO.gets(" > Command:: ")
    [command, _] = String.split( cmd, "\n")
    command |> execute()
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
    IO.puts " 🌟 Le toille says: I can't understand U. Try again"
    cli()
  end

end
