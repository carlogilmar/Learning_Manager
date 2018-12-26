defmodule Etoile.UserManager do
  alias Etoile.RequestManager

  def create_user( username ) do
    user = %{ username: username }
    RequestManager.post("/users.json", user)
  end

end
