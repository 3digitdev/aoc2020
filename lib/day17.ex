defmodule Day17 do
    def run do
        lines = Input.read_file("day17")
        part1(lines)
        part2(lines)
    end

    defp neighbors(conway, {x, y, z}) do
        (for xo <- -1..1, 
            yo <- -1..1, 
            zo <- -1..1,
            {xo, yo, zo} != {0, 0, 0},
            do: Map.get(conway, {x + xo, y + yo, z + zo}, ".")
        ) |> Enum.reduce(0, &(&2 + (if &1 == "#" do 1 else 0 end)))
    end

    defp neighbors4d(conway, {x, y, z, w}) do
        (for xo <- -1..1, 
            yo <- -1..1, 
            zo <- -1..1,
            wo <- -1..1,
            {xo, yo, zo, wo} != {0, 0, 0, 0},
            do: Map.get(conway, {x + xo, y + yo, z + zo, w + wo}, ".")
        ) |> Enum.reduce(0, &(&2 + (if &1 == "#" do 1 else 0 end)))
    end

    defp update_cube([], _, _, result), do: result
    defp update_cube([coords|rest], neighbor_fn, conway, result) do
        live = neighbor_fn.(conway, coords)
        result = case Map.get(conway, coords) do
            "#" when live < 2 or live > 3 -> Map.put(result, coords, ".")
            "." when live == 3 -> Map.put(result, coords, "#")
            _ -> result
        end
        update_cube(rest, neighbor_fn, conway, result)
    end

    defp game_tick(conway, _, count) when count == 0, do: conway
    defp game_tick(conway, neighbor_fn, count) do
        conway = update_cube(Map.keys(conway), neighbor_fn, conway, conway)
        game_tick(conway, neighbor_fn, count - 1)
    end

    defp count_active(conway) do
        conway |> Map.values |> Enum.count(&(&1 == "#"))
    end

    defp part1(lines) do
        initial = for x <- 0..(length(lines) - 1),
            y <- 0..(length(lines) - 1),
            cell = (lines |> Enum.at(x) |> String.split("") |> Enum.filter(&(&1 != "")) |> Enum.at(y)),
            cell != ".",
            do: {x, y, 0}
        conway = for x <- -7..15, y <- -7..15, z <- -7..7, 
            into: %{}, 
            do: {{x, y, z}, (if {x, y, z} in initial do "#" else "." end)}
        conway = game_tick(conway, &neighbors/2, 6)
        IO.puts "17-1: There are #{count_active(conway)} active cells after 6 rounds"
    end

    defp part2(lines) do
        initial = for x <- 0..(length(lines) - 1),
            y <- 0..(length(lines) - 1),
            cell = (lines |> Enum.at(x) |> String.split("") |> Enum.filter(&(&1 != "")) |> Enum.at(y)),
            cell != ".",
            do: {x, y, 0, 0}
        conway = for x <- -7..15, y <- -7..15, z <- -7..7, w <- -7..7, 
            into: %{}, 
            do: {{x, y, z, w}, (if {x, y, z, w} in initial do "#" else "." end)}
        conway = game_tick(conway, &neighbors4d/2, 6)
        IO.puts "17-2: There are #{count_active(conway)} active cells after 6 rounds"
    end
end