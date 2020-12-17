defmodule Day12 do
    def run do
        commands = Input.read_file("day12")
        commands = commands |> Enum.map(fn(l) ->
            [_, cmd, num] = Regex.run(~r/([NSEWLRF])(\d+)/, l)
            {cmd, String.to_integer(num)}
        end)
        part1(commands)
        part2(commands)
    end

    defmodule Ship do
        defstruct [facing: 0, east: 0, north: 0]
    end

    defmodule Waypoint do
        defstruct [n: 1, e: 10, w: 0, s: 0]
    end

    defp turn_ship(ship, cmd, num) do
        %Ship{ ship | facing:
            case cmd do
                "L" -> 
                    f = (div((ship.facing * 90) + num, 90))
                    if f >= 4 do (f - 4) else f end
                "R" -> 
                    f = (div((ship.facing * 90) - num, 90))
                    if f < 0 do 4 - (f * -1) else f end
                _ ->
                    ship.facing
            end
        }
    end

    defp part1(commands) do
        ship = commands |> Enum.reduce(%Ship{}, fn({cmd, num}, ship) ->
            cond do
                cmd == "N" or (cmd == "F" and ship.facing == 1) ->
                    %Ship{ship | north: ship.north + num}
                cmd == "S" or (cmd == "F" and ship.facing == 3) -> 
                    %Ship{ship | north: ship.north - num}
                cmd == "E" or (cmd == "F" and ship.facing == 0) -> 
                    %Ship{ship | east: ship.east + num}
                cmd == "W" or (cmd == "F" and ship.facing == 2) -> 
                    %Ship{ship | east: ship.east - num}
                true -> turn_ship(ship, cmd, num)
            end
        end)
        IO.puts "12-1: The Manhattan distance is [#{abs(ship.east) + abs(ship.north)}]"
    end

    defp rotate_wp(wp, cmd, num) do
        Enum.reduce(0..(div(num, 90) - 1), wp, fn(_, wp) ->
            case cmd do
                "L" -> %Waypoint{n: wp.e, w: wp.n, s: wp.w, e: wp.s}
                "R" -> %Waypoint{n: wp.w, e: wp.n, s: wp.e, w: wp.s}
                _ -> raise "ERROR: #{cmd} #{num}"
            end
        end)
    end

    defp part2(commands) do
        {ship, _} = commands |> Enum.reduce({%Ship{}, %Waypoint{}}, fn({cmd, num}, {ship, wp}) ->
            case cmd do
                "N" -> {ship, %Waypoint{wp | n: wp.n + num}}
                "S" -> {ship, %Waypoint{wp | s: wp.s + num}}
                "E" -> {ship, %Waypoint{wp | e: wp.e + num}}
                "W" -> {ship, %Waypoint{wp | w: wp.w + num}}
                "F" -> {%Ship{ship | 
                        north: ship.north + (wp.n * num) - (wp.s * num),
                        east: ship.east + (wp.e * num) - (wp.w * num)
                    }, wp}
                c -> {ship, rotate_wp(wp, c, num)}
            end
        end)
        IO.puts "12-2: The Manhattan distance is [#{abs(ship.east) + abs(ship.north)}]"
    end
end