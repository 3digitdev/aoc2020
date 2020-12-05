defmodule Day3 do
    def run do
        IO.puts "---- DAY 3 ----"
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
                    case taken do
                        "#" -> 
                            {trees + 1, i, 1}
                        _ ->
                            {trees, i, 1}
                    end
                end
            end)
        trees
    end

    defp part1(lines) do
        IO.puts "There are #{traverse(lines, 3, 1)} trees in the path"
    end

    defp part2(lines) do
        total = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
            |> Enum.map(fn({r, d}) -> traverse(lines, r, d) end)
            |> Enum.reduce(1, &*/2)
        IO.puts "The product of the tree totals is #{total}"
    end
end