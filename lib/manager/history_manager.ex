defmodule Etoile.HistoryManager do

  alias Etoile.BudgetManager
  alias Etoile.NoteManager
  alias Etoile.TaskManager
  alias Etoile.Parser

  def display_timeline_history( week, year, username ) do
    Parser.print_with_color " ::: H I S T O R Y :: Week #{week} Year #{year}  ::: ", :color167
    BudgetManager.get_budgets( username, week, year ) |> BudgetManager.print_budgets()
    Parser.print_with_color " - - - - - - - - - - - - - - - -", :color167
    NoteManager.get_notes( username, week, year ) |> NoteManager.print_notes()
    Parser.print_with_color " - - - - - - - - - - - - - - - -", :color167
    TaskManager.display_tasks_history( username, week, year )
  end

end
