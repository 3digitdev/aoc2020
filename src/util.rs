use std::fs;
use std::str::Split;

pub fn read_file(path: &str) -> String {
    fs::read_to_string(path).unwrap()
}