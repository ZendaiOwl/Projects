use std::io;
use std::cmp::Ordering;
use rand::Rng;

pub struct SomeNr {
    random_value: u8,
    counter: u32,
}

impl SomeNr {
    // fn value(&self) -> u8 {
    //     self.value
    // }
    fn new() -> SomeNr {
        SomeNr { random_value: rand::thread_rng().gen_range(1..=255), counter: 0 }
    }
    fn int(&self) -> u8 {
        self.random_value
    }
    fn increment(&mut self) {
        self.counter += 1;
    }
    fn string(&self) -> [String; 2] {
        [self.random_value.to_string(), self.counter.to_string()]
        // format!("Answer: {}\nAttempts: #{}", self.random_value, self.counter)
    }
}

// enum IPv4 {
//     Address(octals: (u8,u8,u8,u8))
// }
// 
// enum IPv6 {
//     Address: String,
// }
// 
// pub enum IpAddress {
//     Value(Vec<String>),
//     V4(IPv4::Address),
//     V6(IPv6::Address),
//     Valid(bool),
// }

// impl IPv4 {
//     fn valid(&self) -> bool {
//         self.valid
//     }
//     
//     fn string(&self) -> &str {
//         let mut s = String::new();
//         for x in self.string_value {
//             s += x;
//         }
//         &s
//     }
// }

fn main() {

    let mut rn = SomeNr::new();
    println!("Guess the number!");
    loop {
        rn.increment();
        println!("Answer: {}\nAttempt: #{}", rn.string()[0], rn.string()[1]);
        println!("Please input your guess.");
    
        let mut guess = String::new();
    
        io::stdin()
            .read_line(&mut guess)
            .expect("Failed to read line");
    
        let guess: u8 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };
    
        match guess.cmp(&rn.int()) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => {
                println!("You win!");
                break;
            }
        }
    }
}
