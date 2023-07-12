// use std::*;
// use std::{fs, io};
// use std::io::{BufRead, BufReader};
// use std::path::{Path, PathBuf};
// use colored::Colorize;
#[allow(unused_imports)]
use std::io::prelude::*;
use dev::Tree;

#[cfg(test)]
mod tests {
    // use super::*;
}

fn main() {
    /**/
    if std::env::args().len() == 2 {
        let s = std::env::args().nth(1).expect("No argument given");
        let mut dt = Tree::create(&s);
        dt.iterate();
        //Tree::print(&dt);
    } else {
        let mut dt = Tree::new();
        dt.iterate();
        //Tree::print(&dt);
    }
}
