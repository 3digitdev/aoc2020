defmodule Day11r do
    def run do
        seats = Input.readFile("day11")
            |> Enum.map(&(for <<c <- &1>>, do: <<c>>))  # split binary string into chars
        seats = for {row, r} <- Enum.with_index(seats),
            {col, c} <- Enum.with_index(row),
            into: %{},
            do: {{r, c}, col}
        part2(seats)
        # [&part1/1, &part2/1] 
        #     |> Enum.map(&Task.async(fn -> &1.(seats) end))
        #     |> Enum.each(&Task.await(&1, 10_000))
    end

    defp neighbors(seats, {r, c}) do
        (for ro <- -1..1,
            co <- -1..1,
            {ro, co} != {0, 0},
            do: Map.get(seats, {r + ro, c + co}, ".")
        ) |> Enum.reduce(0, &(&2 + (if &1 == "#" do 1 else 0 end)))
    end

    defp los_neighbors(seats, {r, c}) do
        (for ro <- -1..1,
            co <- -1..1,
            {ro, co} != {0, 0},
            do: {ro, co}
        ) |> Enum.reduce(0, fn({ro, co}, total) ->
            {sub, _} = Stream.cycle(0..1)
                |> Enum.reduce_while({total, 1}, fn(_, {subtotal, add}) ->
                    case Map.get(seats, {ro * add + r, co * add + c}) do
                        "#" -> {:halt, {1, add}}
                        "L" -> {:halt, {0, add}}
                        :nil -> {:halt, {0, add}}
                        _ -> {:cont, {0, add + 1}}
                    end
                end)
            total + sub
        end)
    end

    defp check_toggle(seats, coords, live, new, chk) do
        if chk.(live) do Map.update!(seats, coords, fn(_) -> new end) else seats end
    end

    defp count_taken(seats) do
        Enum.count(for v <- Map.values(seats), v == "#", do: v)
    end

    defp find_stability(part, seats, limit, neighbor_fn) do
        Enum.reduce_while(Stream.cycle(0..1), seats, fn(_, iter_state) ->
            next = Enum.reduce(Map.keys(iter_state), iter_state, fn(coords, new_state) ->
                live = neighbor_fn.(iter_state, coords)
                case Map.get(iter_state, coords) do
                    "L" -> check_toggle(new_state, coords, live, "#", &(&1 == 0))
                    "#" -> check_toggle(new_state, coords, live, "L", &(&1 >= limit))
                    _ -> new_state
                end
            end)
            if next == iter_state do
                IO.puts "#{part}: There are [#{count_taken(next)}] occupied seats"
                {:halt, next}
            else
                {:cont, next}
            end
        end)
    end

    defp part1(seats) do
        find_stability("11-1", seats, 4, &neighbors/2)
    end

    defp part2(seats) do
        find_stability("11-2", seats, 5, &los_neighbors/2)
    end
end