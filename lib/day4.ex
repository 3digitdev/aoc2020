defmodule Day4 do
    def run do
        lines = Input.readFile("day4") 
            |> Enum.chunk_by(&(&1 == ""))
            |> Enum.filter(&(&1 != [""]))
            |> Enum.map(&(Enum.join(&1, " ")))
        fields = ~w(byr iyr eyr hgt hcl ecl pid)s
            |> Enum.reduce(%{}, fn(f, m) -> 
                case Regex.compile("#{f}:(?<data>[^ ]*)") do
                    {:ok, r} -> Map.put(m, f, r)
                    _ -> :nil
                end
            end)
        day1(lines, fields)
        day2(lines, fields)
    end

    defp count_entries(e, f, found \\ 0)
    defp count_entries([], _, found), do: found
    defp count_entries([entry|rest], fields, found) do
        total = fields |> Map.values |> Enum.count(&(Regex.match?(&1, entry)))
        count_entries(rest, fields, if total == 0 do found else found + 1 end)
    end

    defp count_passports(p, f, valid \\ 0)
    defp count_passports([], _, valid), do: valid
    defp count_passports([pass|rest], fields, valid) do
        entries = count_entries(String.split(pass), fields)
        valid = valid + (if entries < Enum.count(fields) do 0 else 1 end)
        count_passports(rest, fields, valid)
    end

    defp day1(lines, fields) do
        IO.puts "4-1: There are [#{count_passports(lines, fields)}] valid passports"
    end

    defp inRange?(data, range), do: String.to_integer(data) in range

    defp fieldValid?(field, reg, entry) do
        data = reg |> Regex.named_captures(entry) |> Map.get("data")
        case field do
            "byr" -> inRange?(data, 1920..2002)
            "iyr" -> inRange?(data, 2010..2020)
            "eyr" -> inRange?(data, 2020..2030)
            "hgt" -> 
                case Regex.named_captures(~r/^(?<i>\d+)(?<m>cm|in)$/, data) do
                    :nil -> false
                    caps ->
                        case Map.get(caps, "m") do
                            "cm" -> inRange?(Map.get(caps, "i"), 150..193)
                            "in" -> inRange?(Map.get(caps, "i"), 59..76)
                            _ -> false
                        end
                end
            "hcl" -> Regex.match?(~r/^#[0-9a-f]{6}$/, data)
            "ecl" -> Regex.match?(~r/^(amb|blu|brn|gry|grn|hzl|oth)$/, data)
            "pid" -> Regex.match?(~r/^\d{9}$/, data)
        end
    end

    defp validate_fields(f, entry, fields, found \\ false)
    defp validate_fields([], _, _, found), do: found
    defp validate_fields([f|rest], entry, fields, found) do
        field = Map.get(fields, f)
        found = found or (Regex.match?(field, entry) and fieldValid?(f, field, entry))
        validate_fields(rest, entry, fields, found)
    end

    defp day2(lines, fields) do
        validPassports = lines
            |> Enum.count(fn(line) ->
                line
                    |> String.split
                    |> Enum.count(&(validate_fields(Map.keys(fields), &1, fields)))
                    == length(Map.keys(fields))
            end)
        IO.puts "4-2: There are [#{validPassports}] ACTUALLY valid passports"
    end
end