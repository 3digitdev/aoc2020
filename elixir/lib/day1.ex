defmodule Day1 do
    def run do
        IO.puts("---- DAY 1 ----")
        nums = Input.readFile("day1")
            |> Enum.map(&(String.to_integer(&1)))
        part1(nums)
        part2(nums)
    end

    defp part1(nums) do
        case nums 
            |> Enum.filter(&(nums |> Enum.member?(2020 - &1)))
            |> List.first do
            :nil -> IO.puts("No answers")
            n -> IO.puts(n * (2020 - n))
        end
    end

    defp part2(nums) do
        result = nums 
            |> Comb.combinations(3) 
            |> Stream.filter(fn(c) -> Enum.reduce(c, &+/2) == 2020 end)
            |> Stream.map(fn(s) -> Enum.reduce(s, &*/2) end)
            |> Enum.take(1)
            |> List.first
        case result do
            :nil -> IO.puts "No result"
            n -> IO.puts n
        end
    end
  end