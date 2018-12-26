defmodule Etoile.UserManager do
  alias Etoile.RequestManager

  def create_user( username ) do
    user = %{ username: username }
    RequestManager.post("/users.json", user)
  end

  def find_user( username ) do
    RequestManager.get("/users.json")
      |> Enum.filter( fn {_id, user} -> user["username"] == username end)
      |> start_session()
  end

  defp start_session([]), do: {:not_found, :no_user}
  defp start_session([{_id, user}]), do: {:user_found, user}

end
