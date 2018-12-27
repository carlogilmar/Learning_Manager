defmodule Etoile.BudgetManager do

  alias Etoile.TimelineManager
  alias Etoile.RequestManager
  alias Etoile.Parser
  alias Etoile.Models.Budget
  alias Etoile.CalendarUtil

  def add_budget( price, username ) do
    [{_id, timeline}] = TimelineManager.find_active_timeline( username )
    {_year, _month, day, _week} = CalendarUtil.get_current_date()
    budget = %{ username: username, price: price, week: timeline["week"], year: timeline["year"], day: day}
    RequestManager.post("/budgets.json", budget)
  end

  def list_budgets( username ) do
    [{_id, timeline}] = TimelineManager.find_active_timeline( username )
    RequestManager.get("/budgets.json")
      |> Enum.filter( fn {_id, budget} -> budget["week"] == timeline["week"]
                                 and budget["year"] == timeline["year"]
                                 and budget["username"] == username  end)
      |> print_budgets()
  end

  defp print_budgets( [] ), do: Parser.print_with_color " Not found. ", :color87
  defp print_budgets( budgets ) do
    Parser.print_with_color " == Budgets Stored == ", :color87
    Enum.each( budgets, fn {_id, budget} ->
      Parser.print_with_color " #{budget["day"]}/#{budget["week"]} #{budget["price"]}", :color87
    end)
  end

end
