defmodule Etoile.Bot do

  @bot :simple_bot
  def bot(), do: @bot
  use ExGram.Bot, name: @bot
  alias Etoile.TimelineManager
  require Logger

  command("timeline")
  command("budgets")
  command("notes")
  command("all")
  command("todo")
  command("done")
  command("wip")
  middleware(ExGram.Middleware.IgnoreUsername)

  def handle({:command, :timeline, %{text: username}}, cnt) do
    timeline = get_active_timeline( username )
    cnt |> answer( timeline )
  end

  def handle({:command, :budgets, %{text: _text}}, cnt) do
    cnt |> answer(" \n Active Timeline \n Here\n Here::")
  end

  def handle({:command, :notes, %{text: _text}}, cnt) do
    cnt |> answer(" \n Active Timeline \n Here\n Here::")
  end

  def handle({:command, :tasks, %{text: _text}}, cnt) do
    cnt |> answer(" \n Active Timeline \n Here\n Here::")
  end

  def handle({:command, :todo, %{text: _text}}, cnt) do
    cnt |> answer(" \n Active Timeline \n Here\n Here::")
  end

  def handle({:command, :wip, %{text: _text}}, cnt) do
    cnt |> answer(" \n Active Timeline \n Here\n Here::")
  end

  def handle({:command, :done, %{text: _text}}, cnt) do
    cnt |> answer(" \n Active Timeline \n Here\n Here::")
  end

  defp get_active_timeline( "" ), do: " Learning Manager :: Adding your current username "
  defp get_active_timeline( username ) do
    [{_id, active}] = TimelineManager.find_active_timeline( username )
    case active do
      [] -> " \n There isn't an active timeline. Please register timeline in learning manager."
      _active -> " \n Active Timeline \n Username: #{username} \n Week #{active["week"]} - #{active["year"]}"
    end
  end

end
