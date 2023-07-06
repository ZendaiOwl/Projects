// use glob::glob;
use rusty::*;

pub fn ls(args: &Vec<String>) {
    match args.len() {
        2 => {
            if Node::is_current_dir_readable() {
                Node::new().print_paths();
            } else {
                Format::Error("Unable to open current directory").print();
            }
        },
        3 => {
            if args[2] == "-a" {
                if Node::is_current_dir_readable() {
                    Node::new_all().print_paths();
                } else {
                    Format::Error("Unable to open current directory").print();
                }
            } else if args[2] == "-r" {
                if Node::is_current_dir_readable() {
                    Tree::new().iterate_fast();
                } else {
                    Format::Error("Unable to open current directory").print();
                }
            } else if args[2].starts_with("-") {
                eprintln!("{}: [ {} ]", error_format("Invalid option"), &args[2]);
            } else {
                if Node::is_readable_path(&args[2]) {
                    Node::create(&args[2]).print_paths();
                } else {
                    Format::Error(&format!("Unable to open directory: {}", args[2])).print();
                }
            } 
        },
        4 => {
            if args[2] == "-a" {
                if Node::is_readable_path(&args[3]) {
                    Node::create_all(&args[3]).print_paths();
                } else {
                    Format::Error(&format!("Unable to open directory: {}", args[3])).print();
                }
            } else if args[2] == "-r" {
                if Tree::can_read_path(&args[3]) {
                    Tree::create(&args[3]).iterate_fast();
                } else {
                    Format::Error(&format!("Unable to open directory: {}", args[3])).print();
                }
            } else {
                eprintln!("{} [ {} {} ]", error_format("Invalid arguments:"), &args[2], &args[3]);
            }
        },
        _ => {
            eprintln!("{}: [ {}/4 ]", error_format("Invalid number of arguments"), args.len());
        },
    };
}
