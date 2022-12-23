defmodule Aoc22 do
  @moduledoc """
  Documentation for `Aoc22`.
  """

  defmodule Day6 do
    def read_file(file) do
      file
      |> File.read!()
      |> String.split("", trim: true)
    end
  end

  defmodule Day5 do
    def get_tops(file, crane_type) do
      crates = %{
        "1" => ["T", "R", "G", "W", "Q", "M", "F", "P"],
        "2" => ["R", "F", "H"],
        "3" => ["D", "S", "H", "G", "V", "R", "Z", "P"],
        "4" => ["G", "W", "F", "B", "P", "H", "Q"],
        "5" => ["H", "J", "M", "S", "P"],
        "6" => ["L", "P", "R", "S", "H", "T", "Z", "M"],
        "7" => ["L", "M", "N", "H", "T", "P"],
        "8" => ["R", "Q", "D", "F"],
        "9" => ["H", "P", "L", "N", "C", "S", "D"]
      }

      file
      |> read_file()
      |> Enum.reduce(crates, fn x, acc ->
        x |> move_crates(acc, crane_type)
      end)
    end

    def move_crates(line, crates, crane_type) do
      {number_to_move, from, to} = convert_to_numbers(line)
      {movers, stayers} = Enum.split(crates[from], number_to_move)

      new_to =
        case crane_type do
          :regular_crane -> Enum.reverse(movers) ++ Map.fetch!(crates, to)
          :fancy_crane -> movers ++ Map.fetch!(crates, to)
        end

      crates
      |> Map.replace!(to, new_to)
      |> Map.replace!(from, stayers)
    end

    def read_file(file) do
      file
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.drop(9)
    end

    def convert_to_numbers(line) do
      numbers = line |> String.split(" ")
      {Enum.at(numbers, 1) |> String.to_integer(), Enum.at(numbers, 3), Enum.at(numbers, 5)}
    end
  end

  defmodule Day4 do
    # First >= first
    # last <= last
    # if that doesn't work, flip and repeat

    def overlaps_at_all(file) do
      file
      |> read_file()
      |> Enum.reduce(0, fn x, acc ->
        y =
          x
          |> make_ranges()
          |> check_overlap()

        y + acc
      end)
    end

    def sum_overlaps(file) do
      file
      |> read_file()
      |> Enum.reduce(0, fn x, acc ->
        y =
          x
          |> make_ranges()
          |> check_range()

        y + acc
      end)
    end

    def check_overlap([{a, b}, {c, d}]) do
      cond do
        Enum.member?(c..d, a) -> 1
        Enum.member?(c..d, b) -> 1
        Enum.member?(a..b, c) -> 1
        Enum.member?(a..b, d) -> 1
        true -> 0
      end
    end

    def check_range([{a, b}, {c, d}]) do
      cond do
        a >= c && b <= d -> 1
        c >= a && d <= b -> 1
        true -> 0
      end
    end

    def make_ranges(set) do
      [first_string, second_string] = String.split(set, ",")
      first_set = make_individual_range(first_string)
      second_set = make_individual_range(second_string)
      [first_set, second_set]
    end

    def make_individual_range(pre_split_set) do
      [first_number, second_number] = String.split(pre_split_set, "-")
      {String.to_integer(first_number), String.to_integer(second_number)}
    end

    def read_file(file) do
      file
      |> File.read!()
      |> String.trim_trailing()
      |> String.split("\n")
    end
  end

  defmodule Day3 do
    def groups_of_three(file) do
      file
      |> read_file()
      |> Enum.chunk_every(3)
      |> Enum.reduce(0, fn x, acc ->
        priority =
          x
          |> dupes_in_list()
          |> prioritize()

        acc + priority
      end)
    end

    def sum_priorities(file) do
      file
      |> read_file()
      |> Enum.reduce(0, fn x, acc ->
        priority =
          x
          |> split_in_half()
          |> dupes_in_tuple()
          |> prioritize()

        acc + priority
      end)
    end

    def prioritize(input) do
      lower = ?a..?z |> Enum.to_list()
      upper = ?A..?Z |> Enum.to_list()

      full_list =
        (lower ++ upper)
        |> Enum.to_list()

      index =
        Enum.find_index(
          full_list,
          fn x ->
            x == List.first(input)
          end
        )

      index + 1
    end

    def dupes_in_list([a, b, c]) do
      z = dupes_in_tuple({a, b})
      dupes_in_tuple({"#{z}", c})
    end

    def dupes_in_tuple({a, b}) do
      left = String.to_charlist(a) |> MapSet.new()
      right = String.to_charlist(b) |> MapSet.new()

      MapSet.intersection(left, right)
      |> MapSet.to_list()
      |> Kernel.to_charlist()
    end

    def split_in_half(string) do
      split_point = div(String.length(string), 2)

      string
      |> String.split_at(split_point)

      # returns tuple
    end

    def read_file(file) do
      file
      |> File.read!()
      |> String.split("\n")
      |> Enum.reverse()
      |> Kernel.tl()
      |> Enum.reverse()
    end
  end

  defmodule Day2 do
    # DAY 2
    # find winner
    # calculate round score
    # calculate total score
    #
    # 1 rock, 2 paper, 3 scissors
    # 0 lose, 3 tie, 6 win
    #
    # self
    # x rock 1, y paper 2, z scissors 3
    # opponent
    # a rock, b paper, c scissors
    #
    # Rock defeats Scissors, Scissors defeats Paper, and Paper defeats Rock
    #
    # second part x = lose y = draw z = win

    def score_line("A X"), do: 4
    def score_line("A Y"), do: 8
    def score_line("A Z"), do: 3
    def score_line("B X"), do: 1
    def score_line("B Y"), do: 5
    def score_line("B Z"), do: 9
    def score_line("C X"), do: 7
    def score_line("C Y"), do: 2
    def score_line("C Z"), do: 6
    def score_line(""), do: 0

    def convert_line("A X"), do: score_line("A Z")
    def convert_line("A Y"), do: score_line("A X")
    def convert_line("A Z"), do: score_line("A Y")
    def convert_line("B X"), do: score_line("B X")
    def convert_line("B Y"), do: score_line("B Y")
    def convert_line("B Z"), do: score_line("B Z")
    def convert_line("C X"), do: score_line("C Y")
    def convert_line("C Y"), do: score_line("C Z")
    def convert_line("C Z"), do: score_line("C X")
    def convert_line(""), do: score_line("")

    def part_two(file) do
      file
      |> read_file()
      |> Enum.reduce(0, fn x, acc ->
        convert_line(x) + acc
      end)
    end

    def read_file(file) do
      file
      |> File.read!()
      |> String.split("\n")
    end

    def part_one(file) do
      file
      |> read_file()
      |> Enum.reduce(0, fn x, acc ->
        score_line(x) + acc
      end)
    end
  end

  defmodule Day1 do
    # DAY 1
    # need to find the elf with the most calories
    # each elf's stash is separated with a /n
    #
    # go through each grouping and find its total
    # return list of totals
    #
    # reduce list by
    # put first total as acc
    # if next total is higher, replace acc

    def find_most_calories(file) do
      file
      |> read_and_group()
      |> reduce_list_of_lists()
      |> most_calories()
    end

    def find_top_three(file) do
      file
      |> read_and_group()
      |> reduce_list_of_lists()
      |> top_three()
    end

    def read_and_group(file) do
      file
      |> File.read!()
      |> String.split("\n\n")
      |> Enum.map(fn x ->
        x |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
      end)
    end

    def reduce_list_of_lists(l_o_l) do
      Enum.reduce(l_o_l, [], fn x, acc ->
        get_sum =
          Enum.reduce(x, fn y, acc ->
            y + acc
          end)

        [get_sum | acc]
      end)
    end

    def most_calories(list_of_calories) do
      Enum.reduce(list_of_calories, 0, fn x, acc ->
        if x > acc do
          acc = x
          acc
        else
          acc
        end
      end)
    end

    def top_three(list_of_calories) do
      list_of_calories
      |> Enum.sort(&(&1 >= &2))
      |> Enum.slice(0..2)
      |> Enum.reduce(fn x, acc ->
        x + acc
      end)
    end
  end
end
