defmodule Toille.FirebaseManager do

  alias Toille.Parser

	def add_task( task ) do
		payload = Poison.encode!(task)
		{:ok, _} = HTTPoison.post "https://gameofchats-db1b4.firebaseio.com/tasks.json", payload
	end

  def show_tasks() do
    response = HTTPoison.get! "https://gameofchats-db1b4.firebaseio.com/tasks.json"
    Poison.decode!( response.body ) |> Parser.display_tasks
  end

end
