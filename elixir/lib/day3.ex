defmodule Day3 do
    def run do
        lines = Input.readFile("day3")
        part1(lines)
        part2(lines)
    end

    defp traverse(lines, right, down) do
        {trees, _, _} = lines
            |> Enum.reduce({0, 1, down}, fn(line, {trees, i, skip}) ->
                if skip < down do
                    {trees, i + right, skip + 1}
                else
                    taken = line 
                        |> String.split("") 
                        |> Enum.filter(&(&1 != "")) 
                        |> Stream.cycle 
                        |> Enum.take(i) 
                        |> List.last
                    i = i + right
                    if taken == "#" do
                        {trees + 1, i, 1}
                    else
                        {trees, i, 1}
                    end
                end
            end)
        trees
    end

    defp part1(lines), do: IO.puts "3-1: There are [#{traverse(lines, 3, 1)}] trees in the path"

    defp part2(lines) do
        IO.puts "3-2: The product of the tree totals is [#{
            [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
                |> Enum.map(fn({r, d}) -> traverse(lines, r, d) end)
                |> Enum.reduce(1, &*/2)
        }]"
    end
end