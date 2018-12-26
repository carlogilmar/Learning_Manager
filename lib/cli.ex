defmodule Etoile.Cli do

  alias Etoile.CliOperation
  alias Etoile.CliSession
  alias Etoile.Parser
  alias Etoile.UserManager

  def main(args), do: start_cli(args)

  def start_cli([]), do: CliSession.cli()

  def start_cli(["--user", username]) do
		Parser.print_with_color " Learning Manager 🌟    ", :color228
    Parser.print_with_color " - - - - - - - - - - - -", :color87
    Parser.print_with_color " Login with #{username} ", :color228
    response = UserManager.find_user( username )
    case response do
      {:not_found, _msg} ->
        Parser.print_with_color "==============================================", :color87
        Parser.print_with_color " #{username} not found                       ", :color228
        Parser.print_with_color " Please sign up or login with user registered.", :color228
        Parser.print_with_color "==============================================", :color87
      {:user_found, user} ->
        IO.puts " Hay usuario papa!"
    end

    #CliOperation.cli()
  end

  def start_cli(_args) do
		Parser.print_with_color "=======================================", :color87
    Parser.print_with_color " ERROR: Option not found.              ", :color228
    Parser.print_with_color " Please login with your username:      ", :color228
    Parser.print_with_color "   > learning_manager --user username  ", :color228
		Parser.print_with_color "=======================================", :color87
  end

end
