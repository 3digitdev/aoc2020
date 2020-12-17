defmodule Day8 do
    def run do
        all_cmds = Input.read_file("day8")
            |> Enum.with_index 
            |> Enum.map(&parse_cmd/1) 
            |> Enum.sort(&(&1.line < &2.line))
        part1(all_cmds)
        part2(all_cmds)
    end

    defmodule Cmd do
        defstruct [:line, :cmd, :num, :used]
    end

    defp parse_cmd({cmd, idx}) do
        m = Regex.named_captures(~r/(?<cmd>acc|jmp|nop) (?<num>[\+\-]\d+)/, cmd)
        %Cmd{
            line: idx,
            cmd: Map.get(m, "cmd"), 
            num: m |> Map.get("num") |> String.to_integer, 
            used: false
        }
    end

    defp execute_cmds(all_cmds) do
        {ended, _, global, _} = 0..1
            |> Stream.cycle
            |> Enum.reduce_while({false, [], 0, 0}, fn(_, {ended, used, global, idx}) ->
                cmd = all_cmds |> Enum.at(idx)
                cond do
                    cmd == nil and idx == Enum.count(all_cmds) ->
                        {:halt, {true, used, global, idx}}
                    Enum.member?(used, cmd.line) ->
                        {:halt, {ended, used, global, idx}}
                    true ->
                        case cmd.cmd do
                            "nop" -> {:cont, {ended, used ++ [cmd.line], global, idx + 1}}
                            "jmp" -> {:cont, {ended, used ++ [cmd.line], global, idx + cmd.num}}
                            "acc" -> {:cont, {ended, used ++ [cmd.line], global + cmd.num, idx + 1}}
                            i -> raise "ERROR #{i}"
                        end
                end
            end)
        {ended, global}
    end

    defp part1(all_cmds) do
        {_, global} = execute_cmds(all_cmds)
        IO.puts "8-1: Global value is [#{global}]"
    end

    def swap_cmd(c), do: %Cmd{c | cmd: if c.cmd == "jmp" do "nop" else "jmp" end }

    defp part2(all_cmds) do
        cmd = all_cmds
            |> Enum.filter(&(&1.cmd != "acc"))
            |> Enum.drop_while(fn(cmd) ->
                new_cmds = List.update_at(all_cmds, cmd.line, &swap_cmd/1)
                {ended, _} = execute_cmds(new_cmds)
                !ended
            end)
            |> List.first
        {_, global} = all_cmds 
            |> List.update_at(cmd.line, &swap_cmd/1)
            |> execute_cmds
        IO.puts "8-2: Global value is [#{global}]"
    end
end