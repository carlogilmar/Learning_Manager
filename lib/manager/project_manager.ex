defmodule Etoile.ProjectManager do
  alias Etoile.Parser

  def add_project( project_name ) do
    id = Parser.get_uuid()
    %{ project_id: id, project_name: project_name }
  end

end
