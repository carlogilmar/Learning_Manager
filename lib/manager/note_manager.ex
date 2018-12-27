defmodule Etoile.NoteManager do
  alias Etoile.TimelineManager
  alias Etoile.RequestManager
  alias Etoile.Parser
  alias Etoile.Models.Note
  alias Etoile.CalendarUtil

  def save_note( username, content, label ) do
    [{_id, timeline}] = TimelineManager.find_active_timeline( username )
    {_year, _month, day, _week} = CalendarUtil.get_current_date()
    note = %{ username: username, note: content, label: label, week: timeline["week"], year: timeline["year"], day: day}
    RequestManager.post("/notes.json", note)
  end

  def list_notes( username ) do
  end

end
