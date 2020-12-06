defmodule Day6 do
    def run do
        groups = Input.readFile("day6")
            |> Enum.chunk_by(&(&1 == ""))
            |> Enum.filter(&(&1 != [""]))
            |> Enum.map(&(Enum.join(&1, " ")))
        part1(groups)
        part2(groups)
    end

    defp part1(groups) do
        IO.puts "6-1: The total is [#{groups 
            |> Enum.reduce(0, fn(group, total) ->
                total + (group
                    |> String.replace(" ", "")
                    |> String.split("")
                    |> Enum.filter(&(&1 != ""))
                    |> Enum.uniq
                    |> Enum.count)
            end)
        }]"
    end

    defp part2(groups) do
        IO.puts "6-2: The total is [#{groups
            |> Enum.reduce(0, fn(group, total) ->
                people = String.split(group, " ")
                unique = people
                    |> Enum.reduce(%{}, fn(p, uniq) ->  # Person
                        p 
                            |> String.split("")
                            |> Enum.filter(&(&1 != ""))
                            |> Enum.reduce(uniq, fn(a, u) -> Map.update(u, a, 1, fn(v) -> v + 1 end) end)
                    end)
                total + (unique
                    |> Map.keys
                    |> Enum.filter(&(Map.get(unique, &1) == Enum.count(people)))
                    |> Enum.count)
            end)
        }]"
    end
end