use crate::util::read_file;

pub fn run() {
    println!("---- DAY 3 ----");
    part_1();
    part_2();
}

fn traverse(lines: &String, right: i32, down: i32) -> i64 {
    let mut answer: i64 = 0;
    let (mut x, mut y) = (0usize, 0usize);
    let rows: Vec<&str> = lines.split('\n').collect();
    while y < rows.len() {
        if rows[y].chars().cycle().nth(x) == Some('#') {
            answer += 1;
        }
        x += right as usize;
        y += down as usize;
    }
    answer
}

fn part_1() {
    let lines = read_file("inputs/day3.txt");
    println!("Total of [{}] trees", traverse(&lines, 3, 1));
}

fn part_2() {
    let lines = read_file("inputs/day3.txt");
    let mut answer = 1;
    for (right, down) in vec![(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)] {
        answer *= traverse(&lines, right, down);
    }
    println!("Total product of trees is [{}]", answer);
}