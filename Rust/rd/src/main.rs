use std::io::{self, BufReader};
use std::io::Write;
use std::io::prelude::*;
use std::fs::File;

fn main() -> io::Result<()> {
  let path = std::env::args().nth(1).expect("Not a file");
  let file = File::open(&path)?;
  let file = BufReader::new(file);
  let stdout = io::stdout();
  let mut handle = stdout.lock();
  for line in file.lines() {
    writeln!(handle, "{}", line.unwrap())?;
  }
  Ok(())
}
