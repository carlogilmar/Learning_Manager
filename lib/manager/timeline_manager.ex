defmodule Etoile.TimelineManager do

  alias Etoile.Models.Timeline
  alias Etoile.RequestManager
  alias Etoile.CalendarUtil
  alias Etoile.Parser

  def create( username ) do
    {year, _month, _day, week} = CalendarUtil.get_current_date()
    timeline = %Timeline{ username: username, year: year, week: week, status: "ACTIVE" }
    res = validate_timeline( timeline )
    case res do
      [] ->
        RequestManager.post("/timelines.json", timeline)
      timeline ->
		    Parser.print_with_color " [ This timeline is in use. ]", :color228
    end
  end

  def validate_timeline( timeline_to_save ) do
    RequestManager.get("/timelines.json")
      |> Enum.filter(
        fn {_id, timeline} ->
          timeline["username"] == timeline_to_save.username
          and timeline["week"] == timeline_to_save.week
          and timeline["year"] == timeline_to_save.year end )
  end

  def find_active_timeline( username ) do
    res =
      RequestManager.get("/timelines.json")
        |> Enum.filter(
          fn {_id, timeline} ->
            timeline["username"] == username
            and timeline["status"] == "ACTIVE" end )
    case res do
      nil ->
		    Parser.print_with_color " [ Add Timeline for start to use it ]", :color228
      [] ->
		    Parser.print_with_color " [ Add Timeline for start to use it ]", :color228
      [{_id, active}] ->
        CalendarUtil.print_current_week( active["year"], active["week"] )
    end
  end

  def get_all_from_user( username ) do
    res =
      RequestManager.get("/timelines.json")
        |> Enum.filter( fn {_id, timeline} -> timeline["username"] == username end )
    case res do
      nil ->
        Parser.print_with_color " [ You don't have timelines. ]", :color228
      [] ->
		    Parser.print_with_color " [ Add a timeline for start to use it. ]", :color228
      timelines ->
        timelines
          |> Enum.sort_by( fn {_id, timeline} -> timeline["week"]  end)
          |> Enum.each( fn {_id, timeline} ->
            Parser.print_with_color " - Timeline Week #{timeline["week"]} Year #{timeline["year"]}", :color229
          end)
    end
  end

end
