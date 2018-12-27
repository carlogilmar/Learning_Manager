defmodule Etoile.Cli.CliWorker do

  alias Etoile.Parser
  alias Etoile.Cli.CliTimeline
  alias Etoile.TagManager
  alias Etoile.NoteManager
  alias Etoile.BudgetManager

  def cli( user ) do
    execute_command( user )
  end

  def execute_command( user ) do
    receive_command
      |> execute( user )
  end

  def receive_command(), do: IO.gets("\n Working Timeline >> ") |> Parser.parse_command()
  def receive_command( prompt ), do: IO.gets("  #{prompt}") |> Parser.parse_command()

  def display_operate_current_timeline( user ) do
    Parser.print_with_color " === Current Timeline ===", :color87
    Parser.print_with_color " (1) Add note (2) List notes ", :color87
    Parser.print_with_color " (3) Add budget (4) List budgets ", :color87
    Parser.print_with_color " 1. Add task ", :color87
    Parser.print_with_color " 0. Return ", :color87
    execute_command( user )
  end

  def execute( cmd, user ) do
    case cmd do
      "1" ->
        TagManager.list_labels( user["username"] )
        note = receive_command(" Write your note >> ")
        label = receive_command(" Label >> ")
        NoteManager.save_note( user["username"], note, label)
        cli( user )
      "2" ->
        NoteManager.list_notes( user["username"] )
        cli( user )
      "3" ->
        budget = receive_command(" $ today >> ")
        BudgetManager.add_budget( budget, user["username"] )
        cli( user )
      "4" ->
        BudgetManager.list_budgets( user["username"] )
        cli( user )
      "0" ->
        CliTimeline.cli( user )
      _ ->
        cli( user )
    end
  end

end
