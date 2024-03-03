pub fn print(s: &Vec<String>) {
    if s.len() > 2 {
        for i in 2..s.len() {
            println!("{}", &s[i]);
        }
    } else {
        println!("");
    }
}
