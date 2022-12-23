defmodule Aoc22Test do
  use ExUnit.Case
  # doctest Aoc22

  describe "Day 6" do
    assert Kernel.length(Aoc22.Day6.read_file("lib/day6.txt")) == 4096
  end

  describe "Day 5" do
    test "get tops with fancy crane" do
      assert Aoc22.Day5.get_tops("lib/day5.txt", :fancy_crane) ==
        %{
              "1" => ["D", "P", "J", "T", "V"],
              "2" => ["M", "N", "H", "M"],
              "3" => ["R", "Q", "F", "P", "T", "N"],
              "4" => ["D", "Q"],
              "5" => ["F"],
              "6" => ["R", "H", "P", "R", "F", "R", "S", "Q", "D", "P", "P", "M", "G", "L", "L", "S", "W", "W", "Z", "B"],
              "7" => ["H", "P"],
              "8" => ["H", "S", "T", "M", "S", "R", "G", "P", "H", "G", "F", "H", "C", "L", "Z"],
              "9" => ["H"]
            }
    end
    test "get tops" do
      assert Aoc22.Day5.get_tops("lib/day5.txt", :regular_crane) ==
        %{
              "1" => ["T", "M", "M", "Q", "R"],
              "2" => ["P", "R", "S", "H"],
              "3" => ["G", "P", "C", "D", "Z", "T"],
              "4" => ["V", "F"],
              "5" => ["Q"],
              "6" => ["P", "L", "B", "H", "S", "H", "W", "F", "M", "R", "G", "S", "M", "N", "R", "G", "S", "P", "H", "P"],
              "7" => ["F", "F"],
              "8" => ["D", "P", "Q", "D", "J", "H", "N", "T", "L", "W", "Z", "L", "H", "P", "R"],
              "9" => ["H"]
            }
    end
    test "move crates" do
      assert Aoc22.Day5.move_crates("move 3 from 1 to 2",
        %{"1" => [1, 2, 3, 4], "2" => [5, 6]}, :regular_crane) == %{"1" => [4], "2" => [3, 2, 1, 5, 6]}
      end
    assert Aoc22.Day5.move_crates("move 3 from 2 to 1", %{
        "1" => [1, 2, 3, 4],
        "2" => [5, 6]}, :regular_crane) == %{"1" => [6, 5, 1, 2, 3, 4], "2" => []}
    test "convert to numbers" do
      assert Aoc22.Day5.convert_to_numbers("move 3 from 8 to 9") == {3, "8", "9"}
    end
    test "read file removes initial list" do
      assert List.first(Aoc22.Day5.read_file("lib/day5.txt")) == "move 3 from 8 to 9"
    end
  end

  describe "Day 4" do
    test "overlaps at all" do
      assert Aoc22.Day4.overlaps_at_all("lib/day4.txt") == 926
    end
    test "sum of overlaps" do
      assert Aoc22.Day4.sum_overlaps("lib/day4.txt") == 644
    end
    test "check range" do
      assert Aoc22.Day4.check_range([{12, 50}, {13, 40}]) == 1
      assert Aoc22.Day4.check_range([{10, 20}, {11, 19}]) == 1
      assert Aoc22.Day4.check_range([{12, 50}, {51, 60}]) == 0
      assert Aoc22.Day4.check_range([{20, 40}, {11, 19}]) == 0
    end
    test "read file" do
      assert Kernel.length(Aoc22.Day4.read_file("lib/day4.txt")) == 1000
    end
    test "make range" do
      assert Aoc22.Day4.make_ranges("57-87,87-87") == [{57, 87}, {87, 87}]
    end
  end

  describe "Day 3" do
    test "by 3" do
      assert Aoc22.Day3.groups_of_three("lib/day3.txt") == 2525
    end
    test "sum priorities" do
      assert Aoc22.Day3.sum_priorities("lib/day3.txt") == 7581
    end
    test "prioritize lower" do
      assert Aoc22.Day3.prioritize('z') == 26
    end
    test "prioritize upper" do
      assert Aoc22.Day3.prioritize('A') == 27
    end
    test "find in tuple" do
      assert Aoc22.Day3.dupes_in_tuple({"fart", "able"}) == 'a'
    end
    test "split in half" do
      assert Aoc22.Day3.split_in_half("asdfasdf") == {"asdf", "asdf"}
    end
  end

  describe "Day 2" do
    test "first score tally" do
      assert Aoc22.Day2.part_one("lib/day2.txt") == 8890
    end
    test "second score tally" do
      assert Aoc22.Day2.part_two("lib/day2.txt") == 10238
    end
  end
  describe "Day 1" do
    test "most calories" do
      assert Aoc22.Day1.most_calories([1, 2, 3]) == 3
    end
    test "finds the most calories if the same number happens more than once" do
      assert Aoc22.Day1.most_calories([4, 9, 3, 1, 9, 0]) == 9
    end
    test "read and group" do
      assert is_list(Aoc22.Day1.read_and_group("lib/day1.txt"))
    end
    test "reduce list of lists" do
      assert Aoc22.Day1.reduce_list_of_lists([[1, 2, 3], [4], [5, 5]]) == [10, 4, 6]
    end
    test "put it all together" do
      assert Aoc22.Day1.find_most_calories("lib/day1.txt") == 70764
    end
    test "top three" do
      assert Aoc22.Day1.find_top_three("lib/day1.txt") == 203905
    end
  end
end
