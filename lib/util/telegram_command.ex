defmodule Etoile.TelegramCommand do
  alias Etoile.TimelineManager
  alias Etoile.BudgetManager

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
    budgets = BudgetManager.get_budgets( username )
    total = BudgetManager.get_total( budgets )
    lines = for {_id, budget} <- budgets, do: "#{budget["day"]}/#{budget["week"]} #{budget["price"]} #{budget["description"]}"
    header = [" :: Budgets Stored ::"]
    footer = [ " :: Total #{total} ::" ]
    sentence = header ++ lines ++ footer
    Enum.join( sentence, "\n" )
  end
end
