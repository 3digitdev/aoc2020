use crate::util::read_file;
use fancy_regex::Regex;

pub fn run() {
    println!("---- DAY 4 ----");
    part_1();
    part_2();
}

fn reg(code: &str) -> Regex {
    Regex::new(format!("{}:(?<data>[^ ]*)", code).as_str()).unwrap()
}

fn part_1() {
    let lines = read_file("inputs/day4.txt");
    let fields = vec!["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];
    let mut valid = 0;
    let mut found: Vec<&str> = vec![];
    let mut passport = String::new();
    for line in lines.split('\n') {
        if line == "" {
            // validate passport
            for field in &fields {
                let r = reg(field);
                if r.is_match(&passport).unwrap() {
                    found.push(field);
                }
            }
            found.dedup();
            if found.len() == fields.len() {
                valid += 1;
            }
            found = vec![];
            passport.clear();
            continue
        }
        passport.push_str(format!(" {}", line).as_str());
    }
    println!("There are [{}] valid passports", valid);
}

fn is_valid_data(field: &str, reg: Regex, passport: &str) -> bool {
    let groups = reg.captures(passport).unwrap().unwrap();
    let data = groups.name(&"data").unwrap().as_str();
    match field {
        "byr" => {
            let i = data.parse::<i32>().unwrap();
            i >= 1920 && i <= 2002
        },
        "iyr" => {
            let i = data.parse::<i32>().unwrap();
            i >= 2010 && i <= 2020
        },
        "eyr" => {
            let i = data.parse::<i32>().unwrap();
            i >= 2020 && i <= 2030
        },
        "hgt" => {
            let result = Regex::new(r"^(?<i>\d+)(?<m>cm|in)$")
                .unwrap()
                .captures(data)
                .unwrap();
            match result {
                Some(groups) => {
                    let i: i32 = groups.name(&"i").unwrap().as_str().parse().unwrap();
                    let m = groups.name(&"m").unwrap().as_str();
                    if m == "cm" {
                        i >= 150 && i <= 193
                    } else if m == "in" {
                        i >= 59 && i <= 76
                    } else {
                        false
                    }
                },
                _ => false
            }
        },
        "hcl" => Regex::new(r"^#[0-9a-f]{6}$").unwrap().is_match(data).unwrap(),
        "ecl" => Regex::new(r"^(amb|blu|brn|gry|grn|hzl|oth)$").unwrap().is_match(data).unwrap(),
        "pid" => Regex::new(r"^\d{9}$").unwrap().is_match(data).unwrap(),
        _ => true
    }
}

fn part_2() {
    let lines = read_file("inputs/day4.txt");
    let fields = vec!["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];
    let mut valid = 0;
    let mut found: Vec<&str> = vec![];
    let mut passport = String::new();
    for line in lines.split('\n') {
        if line == "" {
            // validate passport
            for field in &fields {
                let r = reg(field);
                if r.is_match(passport.as_str()).unwrap() {
                    if is_valid_data(*field, r, passport.as_str()) {
                        found.push(field);
                    }
                }
            }
            found.dedup();
            if found.len() == fields.len() {
                valid += 1;
            }
            found.clear();
            passport.clear();
            continue;
        }
        passport.push_str(format!(" {}", line).as_str());
    }

    println!("There are [{}] passports with valid data", valid);
}