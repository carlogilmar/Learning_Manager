defmodule Etoile.Cli do

  alias Etoile.CliOperation
  alias Etoile.CliSession
  alias Etoile.Parser

  def main(args), do: start_cli(args)

  def start_cli([]), do: CliSession.cli()

  def start_cli(["--user", username]) do
    IO.puts " ::Learning Manager:: Enviando usuario"
    IO.inspect username
    #Parser.print_with_color "=====================", :color87
		#Parser.print_with_color " Le Etoile App 🌟 !", :color228
		#Parser.print_with_color "=====================", :color87
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
