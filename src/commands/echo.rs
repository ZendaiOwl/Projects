pub fn echo(s: &[String]) {
    if s.len() > 0 {
        for i in 0..s.len() {
            if i != s.len()-1 {
                print!("{} ", &s[i]);
            } else {
                println!("{}", &s[i]);
            }
        }
    } else {
        println!("");
    }
}
