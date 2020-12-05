defmodule Day4 do
    def run do
        IO.puts "---- DAY 4 ----"
        lines = Input.readFile("day4") 
            |> Enum.chunk_by(&(&1 == ""))
            |> Enum.filter(&(&1 != [""]))
            |> Enum.map(&(Enum.join(&1, " ")))
        fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
            |> Enum.reduce(%{}, fn(f, m) -> 
                case Regex.compile("#{f}:(?<data>[^ ]*)") do
                    {:ok, r} -> Map.put(m, f, r)
                    _ -> :nil
                end
            end)
        day1(lines, fields)
        day2(lines, fields)
    end

    defp day1(lines, fields) do
        validPassports = lines
            |> Enum.reduce(0, fn(line, valid) ->
                entries = line
                    |> String.split
                    |> Enum.reduce(0, fn(entry, found) ->
                        case fields |> Map.values |> Enum.filter(&(Regex.match?(&1, entry))) |> Enum.count do
                            0 -> found
                            _ -> found + 1
                        end
                    end)
                if entries < Enum.count(fields) do valid else valid + 1 end
            end)
        IO.puts "There are #{validPassports} valid passports"
    end

    defp inRange?(data, range) do String.to_integer(data) in range end

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

    defp day2(lines, fields) do
        validPassports = lines
            |> Enum.filter(fn(line) ->
                line
                    |> String.split
                    |> Enum.filter(fn(entry) ->
                        fields
                            |> Map.keys
                            |> Enum.reduce(false, fn(f, found) ->
                                found or (Regex.match?(Map.get(fields, f), entry) and fieldValid?(f, Map.get(fields, f), entry))
                            end)
                    end)
                    |> Enum.count == fields |> Map.keys |> Enum.count
            end)
            |> Enum.count
        IO.puts "There are #{validPassports} ACTUALLY valid passports"
    end
end