defmodule Etoile.FirebaseManager do

  alias Etoile.TaskManager
  alias Etoile.Parser
  @firebase_api "https://gameofchats-db1b4.firebaseio.com"

	def add_task( task ) do
    encoded_task =  task  |> Poison.encode!
		{:ok, _} = HTTPoison.post "https://gameofchats-db1b4.firebaseio.com/tasks.json", encoded_task
    Parser.print_with_color " \n 😚 Task added.", :color46
	end

  def show_tasks() do
    response = HTTPoison.get! "https://gameofchats-db1b4.firebaseio.com/tasks.json"
    Poison.decode!( response.body ) |> parser_payload
  end

  def parser_payload( nil ), do: []
  def parser_payload( payload ) do
    for task <- payload do
      { id, attributes } = task
      Map.put( attributes, "firebase_uuid", id)
    end
  end

  def update_task( task_id, status ) do
    { uuid, task }= show_tasks() |> TaskManager.find_task( task_id, status )
    update_request( uuid, task )
  end

  def update_request( uuid, task) do
    payload = task |> Poison.encode!
    "https://gameofchats-db1b4.firebaseio.com/tasks/#{uuid}.json" |> HTTPoison.put( payload )
		Parser.print_with_color "\n TASK #{task["title"]}... was set to: #{task["status"]} 🎉", :color214
  end

  def delete_task( task_id ) do
    { uuid, task }= show_tasks() |> TaskManager.find_task( task_id, "DELETE" )
    "https://gameofchats-db1b4.firebaseio.com/tasks/#{uuid}.json" |> HTTPoison.delete
		Parser.print_with_color "\n TASK #{task["title"]}... was DELETED! 🗑 ", :color214
  end

  def show_projects() do
    response  = HTTPoison.get! "#{@firebase_api}/projects.json"
    Poison.decode!( response.body ) |> parser_payload
  end

  def add_project( project ) do
    encoded_project = project |> Poison.encode!
		{:ok, _} = HTTPoison.post "#{@firebase_api}/projects.json", encoded_project
    Parser.print_with_color " \n 😚 Project added.", :color46
  end

end
