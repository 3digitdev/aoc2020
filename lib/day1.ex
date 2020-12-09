defmodule Day1 do
    def run do
        nums = Input.readFile("day1")
            |> Enum.map(&(String.to_integer(&1)))
        part1(nums)
        part2(nums)
    end

    defp part1(nums) do
        IO.puts "1-1: [#{case nums 
            |> Enum.filter(&(nums |> Enum.member?(2020 - &1)))
            |> List.first do
            :nil -> "No answers"
            n -> n * (2020 - n)
        end}]"
    end

    defp part2(nums) do
        # Credit to https://dev.to/patryk/comment/18ja3
        # I learned more about generators today!
        [result | _] = for x <- nums,
            y <- nums,
            z <- nums,
            x + y + z == 2020,
            do: x * y * z
        IO.puts "1-2: [#{result}]"

        # Old solution:
        # result = nums 
        #     |> Comb.combinations(3) 
        #     |> Stream.filter(fn(c) -> Enum.reduce(c, &+/2) == 2020 end)
        #     |> Stream.map(fn(s) -> Enum.reduce(s, &*/2) end)
        #     |> Enum.take(1)
        #     |> List.first
        # IO.puts "1-2: [#{case result do
        #     :nil -> "No result"
        #     n -> n
        # end}]"
    end
  end