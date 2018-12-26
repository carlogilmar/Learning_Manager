defmodule Etoile.TimelineManager do

  alias Etoile.Models.Timeline
  alias Etoile.RequestManager
  alias Etoile.CalendarUtil

  def create( username ) do
    {year, _month, _day, week} = CalendarUtil.get_current_date()
    timeline = %Timeline{ username: username, year: year, week: week, status: "ACTIVE" }
    RequestManager.post("/timelines.json", timeline)
  end

end
