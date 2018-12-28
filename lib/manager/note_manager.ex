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

  def get_notes( username ) do
    [{_id, timeline}] = TimelineManager.find_active_timeline( username )
    RequestManager.get("/notes.json")
      |> Enum.filter( fn {_id, note} -> note["week"] == timeline["week"]
                                 and note["year"] == timeline["year"]
                                 and note["username"] == username  end)
  end

  def list_notes( username ), do: get_notes( username ) |> print_notes()

  defp print_notes( [] ), do: Parser.print_with_color " Not found. ", :color87
  defp print_notes( notes ) do
    Enum.each( notes, fn {_id, note} ->
      Parser.print_with_color " <#{note["label"]}> #{note["note"]}", :color87
    end)
  end

end
