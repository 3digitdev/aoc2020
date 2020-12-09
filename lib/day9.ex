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
        {sum, all, good} = nums 
            |> Enum.reduce_while(
                {0, [], false}, 
                fn(num, {acc, all, good}) ->
                    cond do
                        (num + acc) > result -> {:halt, {acc, all, false}}
                        (num + acc) == result -> {:halt, {num + acc, all ++ [num], true}}
                        true -> {:cont, {num + acc, all ++ [num], false}}
                    end
                end
            )
        if good do
            cond do
                sum != result -> raise("ERROR:  Good but not result?! #{sum} #{inspect all}")
                true ->
                    all = Enum.sort(all)
                    IO.puts "9-2: The sum of the min/max for the series is (#{List.first(all)} + #{List.last(all)}) = [#{List.first(all) + List.last(all)}]"
            end
        else
            nums |> List.delete_at(0) |> part2(result)
        end
    end
end