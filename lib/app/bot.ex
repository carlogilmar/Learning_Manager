defmodule Etoile.Bot do

  @bot :simple_bot
  def bot(), do: @bot
  use ExGram.Bot, name: @bot
  alias Etoile.TelegramCommand
  require Logger

  command("timeline")
  command("budgets")
  command("notes")
  command("tasks")
  command("todo")
  command("done")
  command("wip")
  middleware(ExGram.Middleware.IgnoreUsername)

  def handle({:command, :timeline, %{text: username}}, cnt) do
    timeline = TelegramCommand.get_active_timeline( username )
    cnt |> answer( timeline )
  end

  def handle({:command, :budgets, %{text: username}}, cnt) do
    budgets = TelegramCommand.get_budgets( username )
    cnt |> answer( budgets )
  end

  def handle({:command, :notes, %{text: username }}, cnt) do
    notes = TelegramCommand.get_notes( username )
    cnt |> answer(notes)
  end

  def handle({:command, :tasks, %{text: username}}, cnt) do
    tasks = TelegramCommand.get_tasks( username )
    cnt |> answer( tasks )
  end

  def handle({:command, :todo, %{text: username}}, cnt) do
    tasks = TelegramCommand.get_todo( username )
    cnt |> answer( tasks )
  end

  def handle({:command, :wip, %{text: username}}, cnt) do
    tasks = TelegramCommand.get_wip( username )
    cnt |> answer( tasks )
  end

  def handle({:command, :done, %{text: username}}, cnt) do
    tasks = TelegramCommand.get_done( username )
    cnt |> answer( tasks )
  end


end
