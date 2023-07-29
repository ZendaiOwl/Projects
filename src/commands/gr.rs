use library::*;

pub fn gr(args: &Vec<String>, writer: impl std::io::Write) {
    match args.len() {
        4 => {
            if Tree::can_open(&std::path::Path::new(&args[3]).to_path_buf()) {
                Tree::file_search(&args[2], &std::path::Path::new(&args[3]).to_path_buf(), writer);
            } else {
                Format::Error(&format!("Unable to open file: {}", &args[3])).print();
            }
        },
        _ => {
            Format::Error(&format!("Invalid number of arguments: {}/2", args.len()-2)).print();
            Format::Info("Use: rusty gr [ Pattern ] [ File ]").print();
        },
    }
}
