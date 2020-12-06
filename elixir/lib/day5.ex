defmodule Day5 do
    def run do
        passes = Input.readFile("day5")
            |> Enum.filter(&(&1 != ""))
            |> Enum.map(&(String.split(&1, "")
            |> Enum.filter(fn(x) -> x != "" end)))
        part1(passes)
        part2(passes)
    end

    defp parseInstruction(instruction, upper, lower, {low, high}) do
        size = high - low
        case instruction do
            i when i == upper -> {low, div(size, 2) + low}
            i when i == lower -> {div(size, 2) + rem(size, 2) + low, high}
            _ -> {low, high}
        end
    end

    defp getBoardingIds(passes) do
        passes
            |> Enum.reduce([],fn(pass, ids) ->
                {row, _} = pass
                    |> Enum.reduce({0, 127}, fn(i, range) ->
                        parseInstruction(i, "F", "B", range)
                    end)
                {col, _} = pass
                    |> Enum.reduce({0, 7}, fn(i, range) ->
                        parseInstruction(i, "L", "R", range)
                    end)
                ids ++ [row * 8 + col]
            end)
    end

    defp part1(passes) do
        high = getBoardingIds(passes) |> Enum.max
        IO.puts "5-1: The highest id is [#{high}]"
    end

    defp part2(passes) do
        ids = getBoardingIds(passes)
        Enum.each(0..127, fn(r) ->
            Enum.each(0..8, fn(c) ->
                id = r * 8 + c
                if not (ids |> Enum.member?(id)) do
                    if ids |> Enum.member?(id - 1) and ids |> Enum.member?(id + 1) do
                        IO.puts "5-2: Your boarding ID is [#{id}]"
                    end
                end
            end)
        end)
    end
end