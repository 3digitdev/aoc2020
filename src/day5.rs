use crate::util::read_file;
use fancy_regex::Regex;
use itertools::Itertools;

pub fn run() {
    println!("---- DAY 5 ----");
    part_1();
    part_2();
}

fn get_ids(lines: String) -> Vec<i32> {
    let mut ids = vec![];
    for pass in lines.split('\n') {
        let mut r_low = 0usize;
        let mut r_high = 127usize;
        let mut c_low = 0usize;
        let mut c_high = 7usize;
        for instruction in pass.split("").filter(|x| x != &"").collect::<Vec<&str>>() {
            match instruction {
                "F" => r_high = ((r_high - r_low) / 2) + r_low,
                "B" => r_low = ((r_high - r_low) / 2) + ((r_high - r_low) % 2) + r_low,
                "L" => c_high = ((c_high - c_low) / 2) + c_low,
                "R" => c_low = ((c_high - c_low) / 2) + ((c_high - c_low) % 2) + c_low,
                _ => continue
            };
        }
        assert_eq!(r_low, r_high);
        assert_eq!(c_low, c_high);
        ids.push((r_low * 8 + c_low) as i32);
    }
    ids
}

fn part_1() {
    let lines = read_file("inputs/day5.txt");
    println!("Highest ID is [{:?}]", get_ids(lines).into_iter().max().unwrap());
}

fn part_2() {
    let lines = read_file("inputs/day5.txt");
    let ids = get_ids(lines);
    for r in 0i32..127 {
        for c in 0i32..7 {
            let id = r * 8 + c;
            if !ids.contains(&id) && ids.contains(&(id - 1)) && ids.contains(&(id + 1)) {
                println!("Your boarding ID is [{}]", id);
            }
        }
    }
}