defmodule AOC do
    def run do
        days = [
            Day1, Day2, Day3, Day4, Day5,
            Day6
        ]
        tasks = days |> Enum.map(&Task.async(fn -> &1.run() end))
        tasks |> Enum.each(&Task.await(&1))
    end
end

defmodule Input do
  def readFile(day) do
    {:ok, lines} = File.read("../inputs/#{day}.txt")
    lines |> String.split("\n")
  end
end