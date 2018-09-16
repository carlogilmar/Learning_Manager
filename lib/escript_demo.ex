defmodule EscriptDemo do

  def main(args) do
    IO.puts "hola a todos!!"
    IO.inspect args
    show_users()
  end

  def show_users() do
    response = HTTPoison.get! "https://gameofchats-db1b4.firebaseio.com/users.json"
    body = Poison.decode!(response.body)
    IO.inspect body
  end

end
