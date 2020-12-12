defmodule Day11 do
    def run do
        seats = Input.readFile("day11")
        part1(seats)
        part2(seats)
    end

    defp at(seats, r, c), do: seats |> Enum.at(r) |> Enum.at(c)

    defp in_bounds?(seats, r, c) do
        r >= 0 and r < Enum.count(seats) and c >= 0 and c < seats |> Enum.at(r) |> Enum.count
    end

    # Used for Part 1
    defp neighbors(seats, row, col) do
        (for r <- -1..1, 
            c <- -1..1, 
            in_bounds?(seats, row + r, col + c),
            {r, c} != {0, 0},
            do: {row + r, col + c})
            |> Enum.reduce(0, fn({r, c}, full) ->
                full + (if seats |> at(r,c) == "#" do 1 else 0 end)
            end)
    end

    # Used for Part 2
    defp los_neighbors(seats, row, col) do
        (for r <- -1..1,
            c <- -1..1,
            {r, c} != {0, 0},
            do: {r, c}
        )
            |> Enum.reduce(0, fn({r, c}, total) ->
                {sub, _} = Enum.reduce_while(
                    Stream.cycle(0..1), {total, 1}, fn(_, {subtotal, add}
                ) ->
                    if in_bounds?(seats, row + (r * add), col + (c * add)) do
                        case seats |> at(row + (r * add), col + (c * add)) do
                            "#" -> {:halt, {1, add}}
                            "L" -> {:halt, {0, add}}
                            _ -> {:cont, {0, add + 1}}
                        end
                    else
                        {:halt, {0, add}}
                    end
                end)
                total + sub
            end)
    end

    defp toggle_seat(seats, r, c) do
        List.update_at(seats, r, fn(row) ->
            List.update_at(row, c, fn(s) ->
                case s do
                    "L" -> "#"
                    "#" -> "L"
                    a -> a
                end
            end)
        end)
    end

    defp count_taken(seats), do: Enum.reduce(seats, 0, fn(r, total) -> total + (r |> Enum.filter(&(&1 == "#")) |> Enum.count) end)

    defp find_stability(part, seats, limit, neighbor_fn) do
        seats = seats |> Enum.map(fn(line) -> line |> String.split("") |> Enum.filter(&(&1 != "")) end)
        indexes = for r <- 0..Enum.count(seats) - 1, c <- 0..(seats |> Enum.at(0) |> Enum.count) - 1, do: {r, c}
        Enum.reduce_while(Stream.cycle(0..1), seats, fn(_, iter_state) ->
            nxt_state = Enum.reduce(indexes, iter_state, fn({row, col}, new_state) ->
                live = neighbor_fn.(iter_state, row, col)
                case iter_state |> at(row, col) do
                    "L" -> if live == 0 do toggle_seat(new_state, row, col) else new_state end
                    "#" -> if live >= limit do toggle_seat(new_state, row, col) else new_state end
                    _ -> new_state
                end
            end)
            if nxt_state == iter_state do
                IO.puts "#{part}: There are [#{count_taken(nxt_state)}] occupied seats"
                {:halt, nxt_state}
            else
                {:cont, nxt_state}
            end
        end)
    end

    defp part1(seats) do
        find_stability("11-1", seats, 4, &neighbors/3)
    end

    defp part2(seats) do
        find_stability("11-2", seats, 5, &los_neighbors/3)
    end
end