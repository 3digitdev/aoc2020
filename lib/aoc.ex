defmodule AOC do
    def run do
        days = [
            Day1, Day2, Day3, Day4, Day5,
            Day6, Day7, Day8, Day9, Day10,
            Day11, Day12
        ]
        tasks = days |> Enum.map(&Task.async(fn -> &1.run() end))
        tasks |> Enum.each(&Task.await(&1, 25_000))
    end
end

defmodule Input do
  def readFile(day) do
    {:ok, lines} = File.read("inputs/#{day}.txt")
    lines |> String.split("\n")
  end
end

defmodule Util do
    # Pass-through debugger for mid-pipe inspections
    def debug(thing, prefix \\ "") do
        IO.puts "#{prefix}: #{inspect thing}"
        thing
    end
end