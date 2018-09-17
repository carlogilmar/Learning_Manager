defmodule Toille.Cli do

  alias Toille.CliOperation

  def main(_args) do
    CliOperation.cli()
  end

end
