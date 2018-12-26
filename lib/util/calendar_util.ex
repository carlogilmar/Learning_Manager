defmodule Etoile.CalendarUtil do

  def get_current_day() do
    date = Date.utc_today
    [{ spanish_month, _}] = get_spanish_month( date.month )
    { date.day, date.month, date.year, spanish_month}
  end

  def get_spanish_month( month ) do
    months = spanish_months()
    Enum.filter( months, fn { _, number } -> number == month end )
  end

  def spanish_months() do
    [
      { "ENE", 1},
      { "FEB", 2},
      { "MAR", 3},
      { "ABR", 4},
      { "MAY", 5},
      { "JUN", 6},
      { "JUL", 7},
      { "AGO", 8},
      { "SEP", 9},
      { "OCT", 10},
      { "NOV", 11},
      { "DIC", 12}
    ]
  end

  def get_duration( end_time, start_time) do
    ms = ((end_time - start_time) / 1000) / 60
  end

end
