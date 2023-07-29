use std::process::Command;
use library::*;
// use std::io::{self, Write};
// use std::ops::Add;
// use std::ffi::OsStr;
// Vec<String>
pub fn run_cmd(arg_cmd: &[String], mut writer: impl std::io::Write) -> bool {
    let mut c = String::new();
    if arg_cmd.len() == 0 {
        Format::Error("No command provided").print();
        return false;
    } else if arg_cmd.len() >= 1 {
        for a in arg_cmd {
            if arg_cmd.len() == 1 {
                c += &a;
            } else {
                c += &String::from(a.to_owned() + " ");
            }
        }
    }
    let output = if cfg!(target_os = "windows") {
        Command::new("cmd")
            .args(["/C", &c])
            .output()
            .expect("failed to execute process")
    } else {
        Command::new("bash")
            .arg("-c")
            .arg(&c)
            .output()
            .expect("failed to execute process")
    };
    
    // let status = if cfg!(target_os = "windows") {
    //     Command::new("cmd")
    //         .args(["/C", &c])
    //         .status()
    //         .expect("failed to execute process")
    // } else {
    //     Command::new("bash")
    //         .arg("-c")
    //         .arg(&c)
    //         .status()
    //         .expect("failed to execute process")
    // };

    // Child Process
    // let mut child = if cfg!(target_os = "windows") {
    //     Command::new("cmd").args(["/C", &c]).spawn().expect("failed to execute process")
    // } else {
    //    Command::new("bash").arg("-c").arg(&c).spawn().expect("failed to execute process")
    // };
    // let ecode = child.wait().expect("Failed to wait on child process");
    // ecode.success()

    // let mut child = Command::new("bash").arg("-c").arg(&c).spawn().expect("failed to execute process");
    // assert_eq!(output.get_program(), "bash");
    // println!("{}", &output.success());

    // io::stdout().write_all(&output.stdout).expect("failed to execute process");
    // io::stderr().write_all(&output.stderr).expect("failed to execute process");

    writer.write_all(&output.stdout).expect("failed to execute process");
    
    // status.success()
    output.status.success()
}
