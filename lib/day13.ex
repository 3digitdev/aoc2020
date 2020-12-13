defmodule Day13 do
    def run do
        [time, buses] = Input.readFile("day13")
        time = String.to_integer(time)
        buses = buses 
            |> String.split(",")
        part1(time, buses)
        # part2(buses)  # This would run eventually, but piss off with your math
    end

    defp part1(time, buses) do
        {bus, wait} = buses
            |> Enum.filter(&(&1 != "x")) 
            |> Enum.map(&String.to_integer/1)
            |> Enum.map(fn(bus) -> {bus, bus - rem(time, bus)} end)
            |> Enum.sort(fn({_, wait}, {_, other}) -> wait < other end)
            |> List.first
        IO.puts("13-1: Bus #{bus} arrives #{wait}min after start;  [#{bus * wait}]")
    end

    defp bus_calc([_|tail], t), do: for {bus, idx} <- tail, do: rem(t, bus) == (bus - idx)

    defp part2(buses) do
        minimum = 100_000_000_000_000
        maximum = Enum.reduce((for bus <- buses, bus != "x", do: String.to_integer bus), 1, &*/2)
        buses = buses |> Enum.with_index
            |> Enum.map(fn({bus, i}) ->
                if bus != "x" do {String.to_integer(bus), i} else {:nil, i} end
            end)
            |> Enum.filter(fn({bus, _}) -> bus != :nil end)
        {bus_1, _} = List.first(buses)
        for t <- minimum..maximum,
            rem(t, bus_1) == 0,
            Enum.all?(bus_calc(buses, t)),
            do: IO.puts "Found one: #{t}"
    end
end