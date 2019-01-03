defmodule Etoile.TelegramCommand do
  alias Etoile.TimelineManager
  alias Etoile.BudgetManager
  alias Etoile.NoteManager
  alias Etoile.TaskManager

  def get_active_timeline( "" ), do: " Learning Manager :: Adding your current username "
  def get_active_timeline( username ) do
    [{_id, active}] = TimelineManager.find_active_timeline( username )
    case active do
      [] -> " \n There isn't an active timeline. Please register timeline in learning manager."
      _active -> " \n Active Timeline \n Username: #{username} \n Week #{active["week"]} - #{active["year"]}"
    end
  end

  def get_budgets( "" ), do: " Learning Manager :: Adding your current username "
  def get_budgets( username ) do
    budgets = BudgetManager.get_budgets_from_active_timeline( username )
    total = BudgetManager.get_total( budgets )
    lines = for {_id, budget} <- budgets, do: "#{budget["day"]}/#{budget["week"]} #{budget["price"]} #{budget["description"]}"
    header = [" :: Budgets Stored ::"]
    footer = [ " :: Total #{total} ::" ]
    sentence = header ++ lines ++ footer
    Enum.join( sentence, "\n" )
  end

  def get_notes( "" ), do: " Learning Manager :: Adding your current username "
  def get_notes( username ) do
    notes = NoteManager.get_notes( username )
    lines = for {_id, note} <- notes, do: " <#{note["label"]}> #{note["note"]} "
    header = [" :: Notes Stored ::"]
    sentence = header ++ lines
    Enum.join( sentence, "\n" )
  end

  def get_tasks( "" ), do: " Learning Manager :: Adding your current username "
  def get_tasks( username ) do
    { todos, doing, done } = TaskManager.list_tasks_per_status( username )
    todos_lines = for {_id, task} <- todos, do: " <#{task["label"]}> #{task["title"]} "
    dones_lines = for {_id, task} <- done, do: " <#{task["label"]}> #{task["title"]} "
    doing_lines = for {_id, task} <- doing, do: " <#{task["label"]}> #{task["title"]} "
    sentence = ["TODO"] ++ todos_lines ++ ["DOING"] ++ doing_lines ++ ["DONE"] ++ dones_lines
    Enum.join( sentence, "\n" )
  end

  def get_todo( "" ), do: " Learning Manager :: Adding your current username "
  def get_todo( username ) do
    { todos, _doing, _done } = TaskManager.list_tasks_per_status( username )
    lines = for {_id, task} <- todos, do: " <#{task["label"]}> #{task["title"]} "
    Enum.join( (["TODO"] ++ lines), "\n" )
  end

  def get_done( "" ), do: " Learning Manager :: Adding your current username "
  def get_done( username ) do
    { _todos, _doing, done } = TaskManager.list_tasks_per_status( username )
    lines = for {_id, task} <- done, do: " <#{task["label"]}> #{task["title"]} "
    Enum.join( (["DONE"] ++ lines), "\n" )
  end

  def get_wip( "" ), do: " Learning Manager :: Adding your current username "
  def get_wip( username ) do
    { _todos, doing, _done } = TaskManager.list_tasks_per_status( username )
    lines = for {_id, task} <- doing, do: " <#{task["label"]}> #{task["title"]} "
    Enum.join( (["DOING"] ++ lines), "\n" )
  end

end
