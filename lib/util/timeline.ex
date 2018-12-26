defmodule Etoile.Util.Timeline do

  alias Etoile.Parser
  alias Etoile.CalendarUtil

  def get_current_date() do
    {:ok, date} = Calendar.DateTime.now("America/Mexico_City")
    {_year, week} = Calendar.Date.week_number(date)
    { date.year, date.month, date.day, week }
  end

  def print_current_day() do
    {year, month, day, week} = get_current_date()
    [{spanish_month, _m}] = CalendarUtil.get_spanish_month( month )
    Parser.print_with_color " Week #{week} :: #{day}-#{spanish_month} #{year}", :color201
  end

  def print_current_week() do
    {year, _month, _day, week} = get_current_date()
    days_in_week = Calendar.Date.dates_for_week_number {year, week}
    [day1, day2, day3, day4, day5, day6, day7] = days_in_week
    Parser.print_with_color " #{day1.day} - #{day2.day} - #{day3.day} - #{day4.day} - #{day5.day} - #{day6.day} - #{day7.day}", :color201
  end

end
