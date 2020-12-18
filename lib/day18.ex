defmodule Day18 do
    def run do
        lines = Input.read_file("day18")
            |> Enum.map(fn(line) ->
                line 
                    |> String.replace(" ", "") 
                    |> String.split("") 
                    |> Enum.filter(&(&1 != ""))
            end)
            |> Enum.filter(&(&1 != []))
        part1(lines)
        part2(lines)
    end

    defp calc([a, b|rest], cfn), do: [cfn.(a, b)|rest]

    defp rpn(tokens, stack \\ [])
    defp rpn([], [result|_]), do: result
    defp rpn([c|tokens], stack) do
        stack = case c do
            "*" -> calc(stack, &*/2)
            "+" -> calc(stack, &+/2)
            n -> [String.to_integer(n)|stack]
        end
        rpn(tokens, stack)
    end

    defp unpack_ops([], out), do: {[], out}
    defp unpack_ops([op|others], out) when op == "(", do: {[op|others], out}
    defp unpack_ops([op|others], out), do: unpack_ops(others, [op|out])

    defp to_infix(c, s \\ [], q \\ [])
    defp to_infix([], ops, out), do: ops |> Enum.reduce(out, &([&1|&2])) |> Enum.reverse
    defp to_infix([c|rest], ops, out) do
        {ops, out} = case c do
            "(" -> {[c|ops], out}
            ")" -> 
                {[_|ops], out} = unpack_ops(ops, out)
                {ops, out}
            "*" -> 
                {ops, out} = unpack_ops(ops, out)
                {[c|ops], out}
            "+" -> 
                {ops, out} = unpack_ops(ops, out)
                {[c|ops], out}
            _ -> {ops, [c|out]}
        end
        to_infix(rest, ops, out)
    end 

    defp part1(lines) do
        result = lines |> Enum.map(&(&1 |> to_infix |> rpn)) |> Enum.sum
        IO.puts "18-1: The sum of all lines is [#{result}]"
    end

    defp unpack_ops2([], _, out), do: {[], out}
    defp unpack_ops2([op|rest], cur, out) when op == "(" or (cur == "+" and op == "*"), do: {[op|rest], out}
    defp unpack_ops2([op|rest], cur, out), do: unpack_ops2(rest, cur, [op|out])

    defp to_infix2(c, s \\ [], q \\ [])
    defp to_infix2([], ops, out), do: ops |> Enum.reduce(out, &([&1|&2])) |> Enum.reverse
    defp to_infix2([c|rest], ops, out) do
        {ops, out} = case c do
            "(" -> {[c|ops], out}
            ")" -> 
                {[_|ops], out} = unpack_ops2(ops, c, out)
                {ops, out}
            "*" -> 
                {ops, out} = unpack_ops2(ops, c, out)
                {[c|ops], out}
            "+" -> 
                {ops, out} = unpack_ops2(ops, c, out)
                {[c|ops], out}
            _ -> {ops, [c|out]}
        end
        to_infix2(rest, ops, out)
    end 

    defp part2(lines) do
        result = lines |> Enum.map(&(&1 |> to_infix2 |> rpn)) |> Enum.sum
        IO.puts "18-2: The sum of all lines with precedence applied is [#{result}]"
    end
end