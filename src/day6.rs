use crate::util::read_file;
use itertools::Itertools;
use std::collections::HashMap;

pub fn run() {
    println!("---- DAY 6 ----");
    part_1();
    part_2();
}

fn part_1() {
    let lines = read_file("inputs/day6.txt");
    let mut group = String::new();
    let mut total: i32 = 0;
    for line in lines.split('\n') {
        if line == "" {
            total += group.chars().unique().count() as i32;
            group.clear();
        }
        group.push_str(format!("{}", line).as_str());
    }
    println!("The sum is [{}]", total);
}

fn part_2() {
    let lines = read_file("inputs/day6.txt");
    let mut group = String::new();
    let mut total: i32 = 0;
    let mut people: i32 = 0;
    for line in lines.split('\n') {
        if line == "" {
            let mut cmap: HashMap<char, i32> = HashMap::new();
            for char in group.chars() {
                let mut val = match cmap.get(&char) {
                    Some(val) => *val,
                    None => 0i32
                };
                cmap.insert(char, val + 1);
            }
            total += cmap.keys().filter(|c| *cmap.get(&c).unwrap() == people).count() as i32;
            people = 0;
            cmap.clear();
            group.clear();
        } else {
            group.push_str(format!("{}", line).as_str());
            people += 1;
        }
    }
    println!("The sum is [{}]", total);
}