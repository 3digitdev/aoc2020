use crate::util::read_file;
use itertools::Itertools;

pub fn run() {
    println!("---- DAY 1 ----");
    part_1();
    part_2();
}

fn part_2() {
    let lines = read_file("inputs/day1.txt");
    let nums: Vec<i32> = lines.split('\n').map(|s| s.parse().unwrap()).collect();
    for combo in nums.into_iter().combinations(3) {
        let check = combo.clone();
        if combo.into_iter().sum::<i32>() == 2020 {
            println!("The answer is [{}]", check.into_iter().product::<i32>());
            break;
        }
    }
}

fn part_1() {
    let lines = read_file("inputs/day1.txt");
    let nums: Vec<i32> = lines.split('\n').map(|s| s.parse().unwrap()).collect();
    for num in &nums {
        if nums.contains(&(2020 - num)) {
            println!("The answer is [{}]", num * (2020 - num));
            break;
        }
    }
}