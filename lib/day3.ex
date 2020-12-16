defmodule Day3 do
    def run do
        lines = Input.readFile("day3")
        part1(lines)
        part2(lines)
    end

    defp get_at(line, i), do: line 
        |> String.split("") |> Enum.filter(&(&1 != "")) 
        |> Stream.cycle |> Enum.take(i) |> List.last

    defp traverse([], _, _, {trees, _, _}), do: trees
    defp traverse([line|tail], right, down, {trees, i, skip}) do
        acc = cond do
            skip < down -> {trees, i + right, skip + 1}
            get_at(line, i) == "#" -> {trees + 1, i + right, 1}
            true -> {trees, i + right, 1}
        end
        traverse(tail, right, down, acc)
    end

    defp part1(lines), do: IO.puts "3-1: There are [#{traverse(lines, 3, 1, {0, 1, 1})}] trees in the path"

    defp part2(lines) do
        result = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
            |> Enum.map(fn({r, d}) -> traverse(lines, r, d, {0, 1, d}) end)
            |> Enum.reduce(1, &*/2)
        IO.puts "3-2: The product of the tree totals is [#{result}]"
    end
end