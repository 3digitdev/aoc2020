defmodule Day14 do
    def run do
        lines = Input.readFile("day14")
            |> Enum.chunk_by(&(Regex.match?(~r/mask/, &1)))
            |> Enum.chunk_every(2)
            |> Enum.map(&List.flatten/1)
        part1(lines)
        part2(lines)
    end

    defp parse_line(line, parse_mem \\ false) do
        if Regex.match?(~r/mask/, line) do 
            for <<c <- (Regex.named_captures(~r/^mask = (?<mask>[X01]+)$/, line) |> Map.get("mask"))>>, do: <<c>>
        else
            memvals = Regex.named_captures(~r/mem\[(?<mem>\d+)\] = (?<val>\d+)/, line)
            if parse_mem do
                Map.update!(memvals, "val", &String.to_integer/1)
                |> Map.update!("mem", &(
                    &1 |> String.to_integer 
                        |> Integer.to_string(2) 
                        |> String.pad_leading(36, "0")
                ))
            else
                Map.update!(memvals, "val", &(
                    &1 |> String.to_integer 
                        |> Integer.to_string(2) 
                        |> String.pad_leading(36, "0")
                ))
                |> Map.update!("mem", &String.to_integer/1)
            end
        end
    end

    defp mask_val(value, mask) do
        bin_val = for <<c <- value>>, do: <<c>>
        (for x <- 0..Enum.count(mask), Enum.at(mask, x) != "X", do: x)
            |> Enum.reduce(bin_val, fn(i, vals) ->
                List.update_at(vals, i, fn(_) -> Enum.at(mask, i) end)
            end)
            |> Enum.join
            |> String.to_integer(2)
    end

    defp parse_instructions(instructions, map \\ %{})
    defp parse_instructions([], map), do: map
    defp parse_instructions([instruction|tail], map) do
        [bitmask|values] = Enum.map(instruction, &(parse_line(&1)))
        map = values
            |> Enum.reduce(map, fn(value, valmap) ->
                Map.put(valmap, Map.get(value, "mem"), mask_val(Map.get(value, "val"), bitmask))
            end)
        parse_instructions(tail, map)
    end

    defp part1(instructions) do
        sum = parse_instructions(instructions) |> Map.values |> Enum.sum
        IO.puts("14-1: The sum of the memory values is [#{sum}]")
    end

    defp mask_char([], bin_mem), do: bin_mem
    defp mask_char([{c, i}|tail], bin_mem) do
        new_mem = if c == "0" do bin_mem else List.update_at(bin_mem, i, fn(_) -> c end) end
        mask_char(tail, new_mem)
    end

    defp cartesian(a, combos \\ [])
    defp cartesian([], combos), do: combos
    defp cartesian([head|tail], combos) do
        if Enum.count(head) == 1 do
            if Enum.count(combos) == 0 do
                cartesian(tail, combos ++ [head])
            else
                cartesian(tail, Enum.map(combos, &(&1 ++ head)))
            end
        else
            if Enum.count(combos) == 0 do
                cartesian(tail, combos ++ [["0"], ["1"]])
            else
                combos = Enum.map(combos, &(&1 ++ ["1"])) ++ Enum.map(combos, &(&1 ++ ["0"]))
                cartesian(tail, combos)
            end
        end
    end

    defp mask_mem(mem, mask) do
        bin_mem = for <<c <- mem>>, do: <<c>>
        mask
            |> Enum.with_index
            |> mask_char(bin_mem)
            |> Enum.reduce([], fn(memchar, memlist) ->
                memlist ++ [if memchar == "X" do ["0", "1"] else [memchar] end]
            end)
            |> cartesian()
            |> Enum.map(&(Enum.join(&1) |> String.to_integer(2)))
    end

    defp parse_instructions2(instructions, map \\ %{})
    defp parse_instructions2([], map), do: map
    defp parse_instructions2([instruction|tail], map) do
        [bitmask|values] = Enum.map(instruction, &(parse_line(&1, true)))
        map = values
            |> Enum.reduce(map, fn(value, valmap) ->
                mask_mem(Map.get(value, "mem"), bitmask)
                    |> Enum.reduce(valmap, fn(mem, vmap) ->
                        Map.put(vmap, mem, Map.get(value, "val"))
                    end)
            end)
        parse_instructions2(tail, map)
    end

    defp part2(instructions) do
        sum = parse_instructions2(instructions) |> Map.values |> Enum.sum
        IO.puts("14-2: The sum of the memory values is [#{sum}]")
    end
end