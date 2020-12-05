defmodule AOC do
    def run do
        Day1.run()
        Day2.run()
        Day3.run()
        Day4.run()
    end
end

defmodule Input do
  def readFile(day) do
    {:ok, lines} = File.read("../inputs/#{day}.txt")
    lines |> String.split("\n")
  end
end