defmodule Etoile.Cli do

  alias Etoile.CliOperation
  alias Etoile.CliSession
  alias Etoile.Parser

  def main(args), do: start_cli(args)

  def start_cli([]) do
    CliSession.cli()
  end

  def start_cli(args) do
    IO.puts " ::Learning Manager:: Enviando usuario"
    #Parser.print_with_color "=====================", :color87
		#Parser.print_with_color " Le Etoile App 🌟 !", :color228
		#Parser.print_with_color "=====================", :color87
    #CliOperation.cli()
    IO.inspect args
  end
end
