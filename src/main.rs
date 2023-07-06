use std::env;
use crate::commands::print::*;
use crate::commands::echo::*;
use crate::commands::gr::*;
use crate::commands::ls::*;
use crate::commands::list::*;
use crate::commands::rd::*;
use crate::commands::run_cmd::*;
use crate::commands::search::*;
use rusty::*;
// use glob::glob;

mod commands;

fn main() {
    let args: Vec<String> = env::args().collect();
    run_program(&args);
}

fn run_program(arg: &Vec<String>) {
    match arg.len() {
        1 => {
            Format::Error("No arguments given").print();
            use_args();
        },
        2.. => {
            if arg[1] == "echo" {
                //echo(&arg);
                let string_array = &arg[2..];
                echo(&string_array);
            } else if arg[1] == "gr" {
                gr(&arg, std::io::stdout().lock());
            } else if arg[1] == "ls" {
                ls(&arg);
            } else if arg[1] == "list" {
                list(&arg);
            } else if arg[1] == "print" {
                print(&arg);
            } else if arg[1] == "rd" {
                rd(&arg);
            } else if arg[1] == "run_cmd" {
                let string_array = &arg[2..];
                run_cmd(&string_array, &mut std::io::stdout().lock());
                // run_cmd(&arg);
            } else if arg[1] == "search" {
                search(&arg);
            } else {
                first_arg_invalid(&arg[1]);
            }
        },
        _ => {
            Format::Error("Invalid argument(s)").print();
        },
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_echo() {
        let v: Vec<String> = vec!["Hello, world!".to_string(), "How are you?".to_string()];
        let result = echo(&v);
        assert_eq!(result, Format::None(&format!("{} {}", &v[0], &v[1])).print());
    }

    #[test]
    fn test_print() {
        let s: Vec<String> = vec!["Hello".to_string(),"World".to_string()];
        let res = print(&s);
        assert_eq!(res, Format::None(&s[0]).print());
        assert_eq!(res, Format::None(&s[1]).print());
    }

    #[test]
    fn test_print_error() {
        let s = "Hello error";
        assert_eq!(Format::Error(&s).print(), print_error(&s));
    }
    
    #[test]
    fn test_error_format() {
        let s = "Hello error";
        let result = Format::Error(s).get();
        assert!(result.contains(s));
    }

    #[test]
    fn test_info_format() {
        let s = "Hello info";
        assert_eq!(info_format(s), Format::Info(&s).get());
    }

    #[test]
    fn test_dir_format() {
        let s = "Hello directory format";
        assert_eq!(dir_format(&s), format!("{}", Format::Dir(&s).get()));
    }

    #[test]
    fn test_file_format() {
        let res_file_format = file_format("Hello file format");
        assert_eq!(res_file_format, "Hello file format");
    }
    /*
    #[test]
    #[ignore]
    fn test_gr() {
        let mut res = Vec::new();
        let s: Vec<String> = vec![
            "rusty".to_string(),
            "search".to_string(),
            "# description = \"\"".to_string(),
            "Cargo.toml".to_string()
        ];
        gr(&s, &mut res);
        let new = String::from_utf8(res);
        assert_eq!(new, Ok("Cargo.toml: # description = \"\"\n".to_string()));
    }
    */
    #[test]
    fn test_run_cmd() {
        let mut result = Vec::new();
        let s: Vec<String> = vec![
            "rusty".to_string(),
            "run_cmd".to_string(),
            "echo".to_string(),
            "lala".to_string()
        ];
        run_cmd(&s, &mut result);
        assert_eq!(result, b"lala\n");
        // assert!(run_cmd(&s, &mut result));
    }
    /*
    #[test]
    #[ignore]
    fn test_search() {
        let mut r = Vec::new();
        let st = match find_matches(&"hello".to_string(),&"./".to_string(),&"./.tst".to_string(),&mut r) {
            Ok(st) => { st },
            Err(e) => { eprintln!("{}", e) },
        };
        assert_eq!(st, ());
        assert_eq!(String::from_utf8(r), Ok("\u{1b}[32m.tst\u{1b}[0m 1: hello\n".to_string()));
        let x: Vec<String> = vec![
            "rusty".to_string(),
            "search".to_string()
        ];
        let xt = search(&x);
        assert_eq!(false, xt);
    }
    */
}
