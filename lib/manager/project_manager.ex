defmodule Etoile.ProjectManager do
  alias Etoile.Parser
	alias Etoile.FirebaseManager

  def add_project( project_name ) do
    id = Parser.get_uuid()
    %{ project_id: id, project_name: project_name }
  end

  def find_project( project_id ) do
    projects = FirebaseManager.show_projects
    Enum.filter( projects, fn project -> project["project_id"] == project_id end )
  end

end
