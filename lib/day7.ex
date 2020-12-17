defmodule Day7 do
    def run do
        rules = Input.read_file("day7")
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

    defp count_parents(%Bag{containers: c, name: n}, parents), do: c 
        |> Enum.reduce(parents ++ [n], &count_parents/2)
    defp count_parents(%Bag{containers: c}), do: c 
        |> Enum.reduce([], &count_parents/2) |> Enum.uniq |> Enum.count

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

    defp parse_bag(b, bagmap \\ %{})
    defp parse_bag([], bagmap), do: bagmap
    defp parse_bag([part|rest], bagmap) do
        bagmap = case part do
            {"children", c} -> Map.put(bagmap, "children", parse_child(c))
            {"name", p} -> Map.put(bagmap, "name", p)
            _ -> bagmap
        end
        parse_bag(rest, bagmap)
    end

    defp parse_rules(containers) do
        leaf = hd(Enum.filter(containers, &(Map.get(&1, "name") == "shiny gold")))
        build_bag({0, leaf}, containers)
    end

    defp format_rules(rules), do: rules 
        |> Enum.map(fn(r) ->
            ~r/(?<name>[\w ]+) bags contain (?<children>.*)/ 
                |> Regex.named_captures(r) 
                |> Map.to_list 
                |> parse_bag 
        end)

    defp part1(rules) do
        leaf = rules
            |> format_rules
            |> parse_rules
        IO.puts "7-1: There are [#{count_parents(leaf)}] containers"
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
        map = for rule <- format_rules(rules),
            into: %{},
            do: {Map.get(rule, "name"), Map.get(rule, "children")}
        IO.puts "7-2: The shiny gold bag contains [#{find_total_bags(map, "shiny gold")}] other bags"
    end
end
