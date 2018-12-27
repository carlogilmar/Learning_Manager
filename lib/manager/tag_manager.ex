defmodule Etoile.TagManager do
  alias Etoile.Models.Tag
  alias Etoile.RequestManager

  def add_label( label, username ) do
    tag = %Tag{ type: "label", username: username, name: label}
    RequestManager.post("/tags.json", tag)
  end

  def list_labels( username ) do
    IO.puts "Show labels"
  end

  def add_place( place, username ) do
    tag = %Tag{ type: "place", username: username, name: place}
    RequestManager.post("/tags.json", tag)
  end

  def list_places( username ) do
    IO.puts "Show places"
  end

end
