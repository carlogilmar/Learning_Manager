defmodule Etoile.RequestManager do

  alias Etoile.Parser
  @firebase_api "https://gameofchats-db1b4.firebaseio.com"

	def post( uri, payload) do
    encoded = payload |> Poison.encode!
		{:ok, _} = HTTPoison.post "#{@firebase_api}#{uri}", encoded
	end

  def get( uri ) do
		response = HTTPoison.get! "#{@firebase_api}#{uri}"
    Poison.decode!( response.body )
  end

end
