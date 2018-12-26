defmodule Etoile.Cli do

  alias Etoile.Cli.CliTimeline
  alias Etoile.Cli.CliSession
  alias Etoile.Parser
  alias Etoile.UserManager

  def main(args), do: start_cli(args)

  def start_cli([]), do: CliSession.cli() # Register User
  def start_cli(["--user", username]) do
    send_start_msg( username )
    response = UserManager.find_user( username )
    case response do
      {:not_found, _msg} ->
        send_not_found_msg( username )
      {:user_found, user} ->
        CliTimeline.display_menu( user )
    end
  end
  def start_cli(_args), do: send_error_msg()

  defp send_start_msg( username ) do
		Parser.print_with_color " Learning Manager 🌟    ", :color228
    Parser.print_with_color " - - - - - - - - - - - -", :color87
    Parser.print_with_color " Login with #{username} ", :color228
  end

  defp send_error_msg() do
		Parser.print_with_color "=======================================", :color87
    Parser.print_with_color " ERROR: Option not found.              ", :color228
    Parser.print_with_color " Please login with your username:      ", :color228
    Parser.print_with_color "   > learning_manager --user username  ", :color228
		Parser.print_with_color "=======================================", :color87
  end

  defp send_not_found_msg( username ) do
    Parser.print_with_color "==============================================", :color87
    Parser.print_with_color " #{username} not found                       ", :color228
    Parser.print_with_color " Please sign up or login with user registered.", :color228
    Parser.print_with_color "==============================================", :color87
  end

end
