defmodule AOC do
    def run do
        Day1.run()
    end
end

defmodule Input do
  def readFile(filename) do
    {:ok, lines} = File.read(filename)
    lines |> String.split |> Enum.filter(fn(x) -> x != "" end)
  end
end