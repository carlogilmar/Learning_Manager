defmodule Etoile.CalendarUtil do

  alias Etoile.Parser

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

  def get_current_date() do
    {:ok, date} = Calendar.DateTime.now("America/Mexico_City")
    {_year, week} = Calendar.Date.week_number(date)
    { date.year, date.month, date.day, week }
  end

  def print_current_day() do
    {year, month, day, week} = get_current_date()
    [{spanish_month, _m}] = get_spanish_month( month )
    Parser.print_with_color " Week #{week} :: #{day}-#{spanish_month} #{year}", :color201
  end

  def print_current_week( year, week ) do
    days_in_week = Calendar.Date.dates_for_week_number {year, week}
    [day1, day2, day3, day4, day5, day6, day7] = days_in_week
    Parser.print_with_color " Timeline: #{day1.day} - #{day2.day} - #{day3.day} - #{day4.day} - #{day5.day} - #{day6.day} - #{day7.day}", :color201
  end
end
