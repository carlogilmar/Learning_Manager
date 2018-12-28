defmodule Etoile.Bot do

  @bot :simple_bot
  def bot(), do: @bot
  use ExGram.Bot, name: @bot
  alias Etoile.TelegramCommand
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
    timeline = TelegramCommand.get_active_timeline( username )
    cnt |> answer( timeline )
  end

  def handle({:command, :budgets, %{text: username}}, cnt) do
    budgets = TelegramCommand.get_budgets( username )
    cnt |> answer( budgets )
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


end
