use fancy_regex::Regex;
use crate::util::read_file;

pub fn run() {
    part_1();
    part_2();
}

fn part_2() {
    let lines = read_file("inputs/day2.txt");
    let re = Regex::new(r"(?<one>\d+)-(?<two>\d+) (?<char>\w): (?<pass>.*)").unwrap();
    let mut valid = 0;
    for line in lines.split('\n') {
        let groups = re.captures(&line).unwrap().unwrap();
        let one = groups.name(&"one").unwrap().as_str().parse::<usize>().unwrap() - 1;
        let two = groups.name(&"two").unwrap().as_str().parse::<usize>().unwrap() - 1;
        let tmp: Vec<char> = groups.name(&"char").unwrap().as_str().chars().collect();
        let ch = tmp.get(0).unwrap();
        let pass: Vec<char> = groups.name(&"pass").unwrap().as_str().chars().collect();
        if &pass[one] == ch {
            if &pass[two] != ch {
                valid += 1;
            }
        } else {
            if &pass[two] == ch {
                valid += 1;
            }
        }
    }
    println!("There are {} valid passwords", valid);
}

fn part_1() {
    let lines = read_file("inputs/day2.txt");
    let re = Regex::new(r"(?<min>\d+)-(?<max>\d+) (?<char>\w): (?<pass>.*)").unwrap();
    let mut valid = 0;
    for line in lines.split('\n') {
        let groups = re.captures(&line).unwrap().unwrap();
        let min = groups.name(&"min").unwrap().as_str().parse().unwrap();
        let max = groups.name(&"max").unwrap().as_str().parse().unwrap();
        let tmp: Vec<char> = groups.name(&"char").unwrap().as_str().chars().collect();
        let ch = tmp.get(0).unwrap();
        let pass = groups.name(&"pass").unwrap().as_str();
        let ch_count = pass.chars().filter(|c| c == ch).count();
        if ch_count >= min && ch_count <= max {
            valid += 1;
        }
    }
    println!("There are {} valid passwords", valid);
}