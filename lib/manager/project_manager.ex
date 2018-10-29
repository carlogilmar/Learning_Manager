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

  def choose_project() do
    # TODO: this is broken when select an fail id
    [ project ] =
    IO.gets(" 📁  Choose Project ::: Id? >>>  " )
      |> Parser.parse_command()
      |> find_project()
    project
  end

  def filter_tasks_by_project( tasks, project_id) do
    Enum.filter( tasks, fn task -> task["project"] == project_id end )
  end
end
