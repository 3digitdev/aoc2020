defmodule Day15 do
    def run do
        nums = [7,14,0,17,11,1,2]
        {last, nums} = List.pop_at(nums, -1)
        map = nums
            |> Enum.with_index
            |> Enum.reduce(%{}, fn({num, i}, tracker) -> Map.put_new(tracker, num, i + 1) end)
        part1(map, last)
        part2(map, last)
    end

    defp turn(prev, _, _, round, limit) when round == (limit + 1), do: prev
    defp turn(prev, map, last, round, limit) do
        last_round = Map.get(map, last)
        {new_map, next} = if last_round != :nil do
            {Map.update!(map, last, fn(_) -> round end), round - last_round}
        else
            {Map.put_new(map, last, round), 0}
        end
        turn(last, new_map, next, round + 1, limit)
    end

    defp part1(map, last) do
        num = turn(0, map, last, Enum.count(Map.keys(map)) + 1, 2_020)
        IO.puts "15-1: The 2,020th number spoken was #{num}"
    end

    defp part2(map, last) do
        num = turn(0, map, last, Enum.count(Map.keys(map)) + 1, 30_000_000)
        IO.puts "15-2: The 30,000,000th number spoken was #{num}"
    end
end