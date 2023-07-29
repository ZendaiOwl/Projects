use library::*;

pub fn list(args: &Vec<String>) {
    match args.len() {
        2 => {
            Tree::new().iterate_fast();
        },
        3 => {
            if Tree::can_read_path(&args[2]) {
                Tree::create(&args[2]).iterate_fast();
            } else {
                Format::Error(&format!("Unable to read directory: {}", &args[2])).print();
            }
        },
        4.. => {
            Format::Error("Invalid number of arguments").print();
        },
        _ => {
            Format::Error("Invalid argument(s)").print();
        },
    }
}
