defmodule Etoile.Cli do

  alias Etoile.CliOperation
  alias Etoile.Parser

  def main(_args) do
		Parser.print_with_color "=====================", :color87
		Parser.print_with_color " Le Etoile App 🌟 !", :color228
		Parser.print_with_color "=====================", :color87
    CliOperation.cli()
  end

end
