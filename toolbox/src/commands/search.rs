use rusty::*;

pub fn search(args: &Vec<String>) {
    match args.len() {
        3 => {
            Tree::new().find_string(&args[2]);
        },
        4 => {
            if Tree::can_read_path(&args[3]) {
                Tree::create(&args[3]).find_string(&args[2]);
            } else {
                Format::Error(&format!("Unable to open directory: {}", args[3])).print();
            }
        },
        _ => {
            Format::Error(&format!("Invalid number of arguments: {}", args.len()-2)).print();
            Format::Info("Use: rusty search [ Pattern ] ([ Path ])").print();
        },
    }
}
