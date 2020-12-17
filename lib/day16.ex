defmodule Day16 do
    def run do
        [rules, ticket, others] = Input.read_file_no_split("day16") |> String.split("\n\n")
        rule_map = 
            for [_, name, r1, r2] <- Regex.scan(~r/([\w\s]+): (\d+\-\d+) or (\d+\-\d+)\n?/, rules),
            nr1 = r1 |> String.split("-") |> Enum.map(&String.to_integer/1),
            nr2 = r2 |> String.split("-") |> Enum.map(&String.to_integer/1),
            into: %{},
            do: {name, {{List.first(nr1), List.last(nr1)}, {List.first(nr2), List.last(nr2)}}}
        my_ticket = ~r/your ticket:\n([\d,]+)/ 
            |> Regex.scan(ticket) 
            |> List.flatten 
            |> List.last 
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)
        other_tickets = 
            for [_, ticket] <- Regex.scan(~r/([\d,]+)\n/, others),
            do: ticket |> String.split(",") |> Enum.map(&String.to_integer/1)
        part1(rule_map, other_tickets)
        part2(rule_map, my_ticket, other_tickets)
    end

    defp valid_value?(r, v, valid \\ false)
    defp valid_value?(_, _, valid) when valid, do: true
    defp valid_value?([], _, valid), do: valid
    defp valid_value?([rule|rest], value, valid) do
        {{r1_low, r1_high}, {r2_low, r2_high}} = rule
        valid = valid or (value in r1_low..r1_high) or (value in r2_low..r2_high)
        valid_value?(rest, value, valid)
    end

    defp find_invalid(t, r, vals \\ [])
    defp find_invalid([], _, vals), do: vals
    defp find_invalid([ticket|others], rules, vals) do
        vals = vals ++ Enum.filter(ticket, &(!valid_value?(Map.values(rules), &1)))
        find_invalid(others, rules, vals)
    end

    defp part1(rules, others) do
        result = others |> find_invalid(rules) |> Enum.sum
        IO.puts "16-1: The error rate is [#{result}]"
    end

    defp get_valid(t, r, valid \\ [])
    defp get_valid([], _, valid), do: valid
    defp get_valid([ticket|others], rules, valid) do
        valid_entries = Enum.map(ticket, &(valid_value?(Map.values(rules), &1)))
        valid = if Enum.all?(valid_entries) do [ticket|valid] else valid end
        get_valid(others, rules, valid)
    end

    defp reduce_rules(ticket, idx, rnames, rules) do
        value = Enum.at(ticket, idx)
        names = Enum.filter(rnames, fn(name) ->
            {{r1_low, r1_high}, {r2_low, r2_high}} = Map.get(rules, name)
            (value in r1_low..r1_high) or (value in r2_low..r2_high)
        end)
        {idx, names}
    end

    defp parse_ticket(t, r, m)
    defp parse_ticket([], _, map), do: map
    defp parse_ticket([ticket|others], rules, map) do
        new_map = for {i, rnames} <- map, into: %{},
            do: reduce_rules(ticket, i, rnames, rules)
        parse_ticket(others, rules, new_map)
    end

    defp map_eliminate(maplist, final \\ %{})
    defp map_eliminate([], final), do: final
    defp map_eliminate(maplist, final) do
        [{i, head}|tail] = Enum.sort(maplist, fn({_, names}, {_, other}) -> 
            length(names) < length(other)
        end)
        rest = tail |> Enum.map(fn({i, entries}) -> {i, Enum.reject(entries, &(&1 in head))} end)
        map_eliminate(rest, Map.put(final, i, head))
    end

    defp part2(rules, ticket, others) do
        valid_tickets = get_valid(others, rules)
        map = for x <- 0..(length(ticket) - 1),
            into: %{},
            do: {x, Map.keys(rules)}
        map = parse_ticket(valid_tickets, rules, map)
        final = map_eliminate(Map.to_list(map))
        final = for {i, entries} <- final,
            entries != [],
            [entry] = entries,
            String.contains?(entry, "departure"),
            do: i
        result = final |> Enum.map(&(Enum.at(ticket, &1))) |> Enum.reduce(&*/2)
        IO.puts "16-2: The final tally is [#{result}]"
    end
end