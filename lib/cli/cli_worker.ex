defmodule Etoile.Cli.CliWorker do

  alias Etoile.Parser
  alias Etoile.Cli.CliTimeline
  alias Etoile.TagManager
  alias Etoile.NoteManager

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
    Parser.print_with_color " Current Timeline ", :color87
    Parser.print_with_color " 1. Add task ", :color87
    Parser.print_with_color " 2. Add budget ", :color87
    Parser.print_with_color " (3) Add note (4) List notes ", :color87
    Parser.print_with_color " 0. Return ", :color87
    execute_command( user )
  end

  def execute( cmd, user ) do
    case cmd do
      "1" ->
        IO.puts " Adding task"
        cli( user )
      "2" ->
        IO.puts " Adding budget"
        cli( user )
      "3" ->
        TagManager.list_labels( user["username"] )
        note = receive_command(" Write your note >> ")
        label = receive_command(" Label >> ")
        NoteManager.save_note( user["username"], note, label)
        cli( user )
      "4" ->
        NoteManager.list_notes( user["username"] )
        cli( user )
      "0" ->
        CliTimeline.cli( user )
      _ ->
        cli( user )
    end
  end

end
