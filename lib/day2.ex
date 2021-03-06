defmodule Day2 do
    def run do
        lines = Input.read_file("day2")
        part1(lines)
        part2(lines)
    end

    defp deconstruct(line) do
        # Map.values returns them alphabetically by capture group
        ~r/(?<a>\d+)-(?<b>\d+) (?<c>\w): (?<d>.*)/
            |> Regex.named_captures(line)
            |> Map.values
    end

    defp charCountValid(passLine) do
        [min, max, char, pass] = deconstruct(passLine)
        [min, max] = [min, max] |> Enum.map(&String.to_integer/1)
        {:ok, char} = Regex.compile(char)
        case char |> Regex.scan(pass) |> Enum.count do
            n when min <= n and n <= max -> 1
            _ -> 0
        end
    end

    defp part1(lines) do
        result = lines |> Enum.map(&charCountValid/1) |> Enum.sum
        IO.puts "2-1: There are [#{result}] valid passwords"
    end

    defp xor(a, b), do: (a and !b) or (!a and b)

    defp charLocValid(passLine) do
        [one, two, char, pass] = deconstruct(passLine)
        [one, two] 
            |> Enum.map(&(String.to_integer(&1) - 1))
            |> Enum.map(&(String.at(pass, &1) == char))
            |> Enum.reduce(false, &xor/2)
    end

    defp part2(lines) do
        result = lines |> Enum.map(&charLocValid/1) |> Enum.filter(&(&1))
        IO.puts "2-2: There are [#{length(result)}] valid passwords"
    end
end