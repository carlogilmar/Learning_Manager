defmodule Etoile.TagManager do
  alias Etoile.Models.Tag
  alias Etoile.RequestManager
  alias Etoile.Parser

  def add_label( label, username ) do
    tag = %Tag{ type: "label", username: username, name: label}
    RequestManager.post("/tags.json", tag)
  end

  def list_labels( username ) do
    RequestManager.get("/tags.json")
      |> filter_by_username( username, "label" )
      |> display_in_console( "Labels" )
  end

  def add_place( place, username ) do
    tag = %Tag{ type: "place", username: username, name: place}
    RequestManager.post("/tags.json", tag)
  end

  def list_places( username ) do
    RequestManager.get("/tags.json")
      |> filter_by_username( username, "place" )
      |> display_in_console( "Places" )
  end

  def filter_by_username( tags, username, type ) do
    Enum.filter( tags, fn {_id, tag} -> tag["username"] == username and tag["type"] == type end)
  end

  def display_in_console( tags, title ) do
    tags_for_show = for {_id, tag} <- tags, do: tag["name"]
    tags_from_user = Enum.join( tags_for_show, " - " )
    Parser.print_with_color "  #{title}: #{tags_from_user}  ", :color228
  end

end
