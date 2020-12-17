defmodule Day6 do
    def run do
        groups = Input.read_file("day6")
            |> Enum.chunk_by(&(&1 == ""))
            |> Enum.filter(&(&1 != [""]))
            |> Enum.map(&(Enum.join(&1, " ")))
        part1(groups)
        part2(groups)
    end

    defp parse_groups([], total), do: total
    defp parse_groups([group|rest], total) do
        total = total + (group
            |> String.replace(" ", "")
            |> String.split("")
            |> Enum.filter(&(&1 != ""))
            |> Enum.uniq
            |> Enum.count)
        parse_groups(rest, total)
    end

    defp part1(groups) do
        IO.puts "6-1: The total is [#{parse_groups(groups, 0)}]"
    end

    defp parse_people(p, map \\ %{})
    defp parse_people([], map), do: map
    defp parse_people([person|people], map) do
        map = person |> String.split("")
            |> Enum.filter(&(&1 != ""))
            |> Enum.reduce(map, &(Map.update(&2, &1, 1, fn(v) -> v + 1 end)))
        parse_people(people, map)
    end

    defp parse_group(g, total \\ 0)
    defp parse_group([], total), do: total
    defp parse_group([group|rest], total) do
        people = String.split(group, " ")
        unique = parse_people(people)
        total = total + (unique
            |> Map.keys
            |> Enum.count(&(Map.get(unique, &1) == Enum.count(people)))
        )
        parse_group(rest, total)
    end

    defp part2(groups) do
        IO.puts "6-2: The total is [#{parse_group(groups)}]"
    end
end