defmodule Mix.Tasks.Aoc do
  use Mix.Task

  @shortdoc "Runs all AOC days implemented"
  def run(_) do
    AOC.run()
  end
end