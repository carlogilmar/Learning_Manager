defmodule Etoile.BudgetManager do

  alias Etoile.TimelineManager
  alias Etoile.RequestManager
  alias Etoile.Parser
  alias Etoile.Models.Budget
  alias Etoile.CalendarUtil

  def add_budget( price, desc, username ) do
    [{_id, timeline}] = TimelineManager.find_active_timeline( username )
    {_year, _month, day, _week} = CalendarUtil.get_current_date()
    budget = %Budget{ username: username, price: price, description: desc, week: timeline["week"], year: timeline["year"], day: day}
    RequestManager.post("/budgets.json", budget)
  end

  def get_budgets( username ) do
    [{_id, timeline}] = TimelineManager.find_active_timeline( username )
    RequestManager.get("/budgets.json")
      |> Enum.filter( fn {_id, budget} -> budget["week"] == timeline["week"]
                                 and budget["year"] == timeline["year"]
                                 and budget["username"] == username  end)
  end

  def list_budgets( username ), do: get_budgets(username) |> print_budgets()

  defp print_budgets( [] ), do: Parser.print_with_color " Not found. ", :color228
  defp print_budgets( budgets ) do
    Parser.print_with_color " ::: Budgets Stored ::: ", :color228
    Parser.print_with_color " ---------------------- ", :color228
    Enum.each( budgets, fn {_id, budget} ->
      Parser.print_with_color " #{budget["day"]}/#{budget["week"]} #{budget["price"]} #{budget["description"]}", :color87
    end)
    Parser.print_with_color " ---------------------- ", :color228
    display_total( budgets )
  end

  def get_total( budgets ) do
    prices = for {_id, budget} <- budgets, do: String.to_integer( budget["price"] )
    prices |> Enum.sum
  end

  def display_total( budgets ) do
    total = get_total( budgets )
    Parser.print_with_color " Balance: #{total} ", :color87
  end

end
