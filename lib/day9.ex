defmodule Day9 do
    def run do
        nums = Input.readFile("day9") |> Enum.map(&String.to_integer/1)
        result = part1(nums)
        part2(nums, result)
    end

    defp validate_set(nums) do
        check = List.last(nums)
        result = nums
            |> List.delete_at(-1)
            |> Comb.combinations(2)
            |> Enum.any?(&(Enum.sum(&1) == check))
        {result, nums}
    end

    defp part1(nums) do
        result = nums
            |> Stream.chunk_every(26, 1, [])
            |> Enum.map(&validate_set/1)
            |> Enum.filter(fn({res, _}) -> not res end)
            |> Enum.map(fn({_, nums}) -> List.last(nums) end)
            |> List.first
        IO.puts "9-1: The first bad value is [#{result}]"
        result
    end

    defp part2([], _) do
        raise("ERROR: Nothing found")
    end
    defp part2(nums, result) do
        {sum, _} = nums 
            |> Enum.reduce_while({0, []}, fn(num, {acc, all}) ->
                cond do
                    (num + acc) > result -> {:halt, {acc, all}}
                    (num + acc) == result -> 
                        all = all ++ [num] |> Enum.sort
                        IO.puts "9-2: The sum of the min/max for the series is [#{List.first(all) + List.last(all)}]"
                        {:halt, {num + acc, all}}
                    true -> {:cont, {num + acc, all ++ [num]}}
                end
            end)
        if sum != result, do: nums |> List.delete_at(0) |> part2(result)
    end
end