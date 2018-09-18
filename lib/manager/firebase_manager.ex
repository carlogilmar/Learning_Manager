defmodule Etoile.FirebaseManager do

	def add_task( task ) do
		payload = Poison.encode!(task)
		{:ok, _} = HTTPoison.post "https://gameofchats-db1b4.firebaseio.com/tasks.json", payload
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
