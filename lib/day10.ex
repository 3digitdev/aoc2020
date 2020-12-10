defmodule Day10 do
    def run do
        jolts = Input.readFile("day10") |> Enum.map(&String.to_integer/1) |> Enum.sort
        jolts = jolts ++ [0, Enum.max(jolts) + 3]
        part1(jolts)
        part2(jolts)
    end

    defp part1(jolts) do
        {_, result} = Enum.reduce(jolts, {0, [0, 0, 0]}, fn(cur, {prev, ls}) ->
            {cur, List.update_at(ls, cur - prev - 1, &(&1 + 1))}
        end)
        result = result
            |> List.update_at(2, &(&1 + 1))
            |> List.delete_at(1)
            |> Enum.reduce(1, &*/2)
        IO.puts "10-1: The final rating is [#{result}]"
    end

    defp tribonacci(n) when n <= 0, do: 0
    defp tribonacci(n) when n == 1 or n == 2, do: 1
    defp tribonacci(n), do: tribonacci(n - 1) + tribonacci(n - 2) + tribonacci(n - 3)

    defp part2(jolts) do
        {_, results, rest} = jolts
            |> Enum.reduce({0, [], []}, fn(n, {prev, combos, combo}) ->
                if n - prev == 3 do
                    {n, combos ++ [combo], [n]}
                else
                    {n, combos, combo ++ [n]}
                end
            end)
        result = Enum.reduce(results ++ [rest], 1, &(&2 * (&1 |> Enum.count |> tribonacci)))
        IO.puts "10-2: The final # of arrangements is [#{result}]"
    end
end