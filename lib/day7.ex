defmodule Day7 do
    def run do
        rules = Input.readFile("day7")
        part1(rules)
        part2(rules)
    end
    
    defmodule Bag do
        defstruct [:name, :num, :containers]
    end

    defp parse_child(child_rules) do
        child_reg = ~r/(?:(?:no other bags)|(?<num>\d+) (?<child>[\w ]+) bags?)[,.]/
        Regex.scan(child_reg, child_rules, [{:capture, :all_but_first}])
    end

    defp count_parents(node, parents), do: Enum.reduce(node.containers, parents ++ [node.name], &count_parents/2)
    defp count_parents(node), do: Enum.reduce(node.containers, [], &count_parents/2) |> Enum.uniq |> Enum.count

    defp build_bag({num, leaf}, containers) do
        name = Map.get(leaf, "name")
        %Bag{
            name: name,
            num: num,
            containers: containers
                |> Enum.filter(
                    &(Map.get(&1, "children") 
                        |> Enum.map(fn(c) -> List.last(c) end) 
                        |> Enum.member?(name)
                    ))
                |> Enum.reduce([], &(&2 ++ [build_bag({num, &1}, containers)]))
        }
    end
    defp build_bag(map) do
        map 
            |> Enum.reduce(%{}, fn(part, parts) ->
                case part do
                    {"children", c} -> Map.put(parts, "children", parse_child(c))
                    {"name", p} -> Map.put(parts, "name", p)
                    _ -> IO.puts parts
                end
            end)
    end

    defp parse_rules(containers) do
        leaf = containers
            |> Enum.filter(&(Map.get(&1, "name") == "shiny gold"))
            |> List.first
        build_bag({0, leaf}, containers)
    end

    defp part1(rules) do
        rule_reg = ~r/(?<name>[\w ]+) bags contain (?<children>.*)/
        leaf = rules 
            |> Enum.map(fn(r) -> Regex.named_captures(rule_reg, r) |> Map.to_list end)
            |> Enum.map(&build_bag/1)
            |> parse_rules
        IO.puts "7-1: There are [#{count_parents(leaf)}] containers"
    end

    defp debug(thing, prefix) do
        IO.puts "#{prefix}: #{inspect thing}"
        thing
    end

    defp find_total_bags(map, name) do
        children = map
            |> Map.get(name)
            |> List.flatten
            |> Enum.chunk_every(2)
        List.foldl(children, 0, fn([num, cname], acc) ->
            n = String.to_integer num
            acc + n + n * find_total_bags(map, cname)
        end)
    end

    defp part2(rules) do
        rule_reg = ~r/(?<name>[\w ]+) bags contain (?<children>.*)/
        total = rules 
            |> Enum.map(fn(r) -> Regex.named_captures(rule_reg, r) |> Map.to_list end)
            |> Enum.map(&build_bag/1)
            |> Enum.reduce(%{}, fn(bag, bag_map) ->
                Map.put(bag_map, Map.get(bag, "name"), Map.get(bag, "children"))
            end)
            # %{<bag_name> => [[<num>, <child_name>], ...]  OR [[]]}
            |> find_total_bags("shiny gold")
        IO.puts "7-2: The shiny gold bag contains [#{total}] other bags"
    end
end
