defmodule Etoile.FirebaseManager do

  alias Etoile.TaskManager

	def add_task( title ) do
    task =
      TaskManager.create_task( title )
        |> Poison.encode!
		{:ok, _} = HTTPoison.post "https://gameofchats-db1b4.firebaseio.com/tasks.json", task
	end

  def show_tasks() do
    response = HTTPoison.get! "https://gameofchats-db1b4.firebaseio.com/tasks.json"
    Poison.decode!( response.body ) |> parser_payload
  end

  def parser_payload( payload ) do
    for task <- payload do
      { id, attributes } = task
      Map.put( attributes, "firebase_uuid", id)
    end
  end

end
