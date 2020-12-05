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

    defp part1(passes) do
        high = passes
            |> Enum.reduce(
                [],
                fn(pass, ids) ->
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
            |> Enum.max
        IO.puts("The highest id is #{high}")
    end

    defp part2(passes) do
        seating = passes
            |> Enum.reduce((for _ <- 1..128, do: for _ <- 1..8, do: false),
            fn(pass, seats) ->
                {row, _} = pass
                    |> Enum.reduce({0, 127}, fn(i, range) ->
                        parseInstruction(i, "F", "B", range)
                    end)
                {col, _} = pass
                    |> Enum.reduce({0, 7}, fn(i, range) ->
                        parseInstruction(i, "L", "R", range)
                    end)
                seats |> List.update_at(row, &(&1 |> List.update_at(col, fn(_) -> true end)))
            end)
    end
end