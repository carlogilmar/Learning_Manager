defmodule Etoile.RequestManager do

  alias Etoile.Parser
  @firebase_api "https://gameofchats-db1b4.firebaseio.com"

	def post( uri, payload) do
    encoded = payload |> Poison.encode!
		{:ok, _} = HTTPoison.post "#{@firebase_api}#{uri}", encoded
    Parser.print_with_color " Request Succesfull ...", :color46
	end

  def get( uri ) do
		response = HTTPoison.get! "#{@firebase_api}#{uri}"
    Poison.decode!( response.body )
  end

end
