defmodule Day5 do
    def run do
        passes = Input.readFile("day5")
            |> Enum.filter(&(&1 != ""))
            |> Enum.map(&(String.split(&1, "")
            |> Enum.filter(fn(x) -> x != "" end)))
        part1(passes)
        part2(passes)
    end

    defp parse_instructions([], _, _, acc), do: acc
    defp parse_instructions([inst|rest], upper, lower, {low, high}) do
        size = high - low
        acc = case inst do
            i when i == upper -> {low, div(size, 2) + low}
            i when i == lower -> {div(size, 2) + rem(size, 2) + low, high}
            _ -> {low, high}
        end
        parse_instructions(rest, upper, lower, acc)
    end

    defp get_boarding_ids(p, ids \\ [])
    defp get_boarding_ids([], ids), do: ids
    defp get_boarding_ids([pass|rest], ids) do
        {row, _} = parse_instructions(pass, "F", "B", {0, 127})
        {col, _} = parse_instructions(pass, "L", "R", {0, 7})
        get_boarding_ids(rest, ids ++ [row * 8 + col])
    end

    defp part1(passes), do: IO.puts "5-1: The highest id is [#{get_boarding_ids(passes) |> Enum.max}]"

    defp part2(passes) do
        ids = get_boarding_ids(passes)
        for r <- 0..127,
            c <- 0..8,
            id = r * 8 + c,
            not Enum.member?(ids, id),
            Enum.member?(ids, id - 1),
            Enum.member?(ids, id + 1),
            do: IO.puts "5-2: Your boarding ID is [#{id}]"
    end
end