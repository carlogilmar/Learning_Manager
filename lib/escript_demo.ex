defmodule EscriptDemo do
  def main(_args) do
    ["Hello, ", :red, :bright, "world!"]
    |> IO.ANSI.format
    |> IO.puts
  end
end
