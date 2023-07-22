use toolbox::*;

pub fn rd(args: &Vec<String>) {
    match args.len() {
        3 => {
            if Node::can_open_filepath(&args[2]) {
                Node::read_file(&args[2], std::io::stdout().lock());
            }
        },
        _ => {
            Format::Error(&format!("Invalid number of arguments: {}/1", args.len()-2)).print();
            Format::Info("Use: rusty rd [ File ]").print();
        },
    };
}
