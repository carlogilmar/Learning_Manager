defmodule Toille.Cli do

  alias Toille.CliOperation
  alias Toille.Parser

  def main(_args) do
		Parser.print_with_color "=====================", :color87
		Parser.print_with_color " Le Toille App 🌟 !", :color228
		Parser.print_with_color "=====================", :color87
    CliOperation.cli()
  end

end
