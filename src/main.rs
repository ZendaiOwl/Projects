use anyhow::{Context, Result};
use clap::Parser;

#[derive(Parser)]
struct Cli {
	pattern: String,
	path: std::path::PathBuf,
}

fn print(s: &str) {
  println!("{}", s);
}

fn main() -> Result<()> {
    let args = Cli::parse();
    let read = std::fs::read_to_string(&args.path)
        .with_context(|| format!("Could not read file `{}`", &args.path.display()))?;
    for line in read.lines() {
      if line.contains(&args.pattern) {
        print(line);
      }
    }
    Ok(())
}
