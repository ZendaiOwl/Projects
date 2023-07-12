// use anyhow::{Context, Result};
// use core::fmt::Display;
// use core::fmt::Formatter;
use std::fmt;
use std::fmt::Display;
use std::fmt::Formatter;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let ip_str = std::env::args().nth(1).ok_or("No ip-address given")?;
    let v: Vec<&str> = ip_str.split('.').collect();
    let mut xi: Vec<u8> = vec![];
    for i in &v {
        if Octet::can_parse(i) == true {
            xi.push(Octet::parse(i));
        };
    }
    if xi.len() == 4 {
        println!("Valid IPv4: {}", IPv4::from_vec(xi));
    } else {
        println!("Invalid IPv4: {}", ip_str);
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use crate::Octet;
    use crate::IPv4;
    #[test]
    fn test_octet() {
        let nr: u8 = 12;
        let st_nr = String::from("12");
        let st = format!("{}", nr);
        let r = Octet::Value(nr);
        assert_eq!(Octet::parse(&st_nr), nr);
        assert_eq!(r.to_string(), st);
        assert_eq!(r.get(), nr);
    }
    #[test]
    fn test_ipv4() {
        let v = [192,168,178,12];
        let tst = IPv4::new(v[0], v[1], v[2], v[3]);
        let st = format!("{}.{}.{}.{}", v[0], v[1], v[2], v[3]);
        let parse_st = IPv4::from_string("192","168","178","12");
        assert_eq!(tst, parse_st);
        assert_eq!(tst.to_string(), st);
        assert_eq!(tst.get(), v);
        assert_eq!(tst.get_octet(1), v[0]);
        assert_eq!(tst.get_octet(2), v[1]);
        assert_eq!(tst.get_octet(3), v[2]);
        assert_eq!(tst.get_octet(4), v[3]);
    }
}

#[derive(Debug)]
//#[derive(PartialEq)]
#[derive(Copy, Clone)]
enum Octet {
    Value(u8),
}

impl Octet {
    #[allow(dead_code)]
    fn new(input: u8) -> Octet {
        Octet::Value(input)
    }
    #[allow(dead_code)]
    fn parse_new(s: &str) -> Octet {
        if Octet::can_parse(s) {
            Octet::Value(Octet::parse(s))
        } else {
            panic!("Invalid octet");
        }
        
    }
    fn get(self) -> u8 {
        match self {
            Self::Value(int) => int,
        }
    }
    fn value(&self) -> &u8 {
        match self {
            Self::Value(int) => int,
        }
    }
    fn can_parse(s: &str) -> bool {
        match s.parse::<u8>() {
            Ok(_) => true,
            Err(_) => false,
        }
    }
    fn parse(s: &str) -> u8 {
        s.parse::<u8>().expect("Invalid octet")
    }
}

impl PartialEq for Octet {
    fn eq(&self, other: &Self) -> bool {
        self.value() == other.value()
    }
}

impl Display for Octet {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        match self {
            Self::Value(int) => write!(f, "{}", int), 
        }
    }
}

#[derive(Debug)]
#[allow(dead_code)]
enum IPv4 {
    Address(Octet,Octet,Octet,Octet),
}

impl IPv4 {
    #[allow(dead_code)]
    fn new(a: u8, b: u8, c: u8, d: u8) -> IPv4 {
        Self::Address(Octet::Value(a),
                      Octet::Value(b),
                      Octet::Value(c),
                      Octet::Value(d))
    }
    #[allow(dead_code)]
    fn create(a: Octet, b: Octet, c: Octet, d: Octet) -> IPv4 {
        Self::Address(a,b,c,d)
    }
    #[allow(dead_code)]
    fn from_vec(v: Vec<u8>) -> IPv4 {
        Self::Address(Octet::Value(v[0]),Octet::Value(v[1]),Octet::Value(v[2]),Octet::Value(v[3]))
    }
    #[allow(dead_code)]
    fn from_string(a: &str, b: &str, c: &str, d: &str) -> IPv4 {
        let st = [a,b,c,d];
        let mut i = Vec::<u8>::new();
        for x in st {
            if Octet::can_parse(x) {
                i.push(Octet::parse(x));
            }
        }
        if i.len() == 4 {
            Self::from_vec(i)
        } else {
            panic!("Invalid: {a}.{b}.{c}.{d}")
        }
    }
    fn first_octet(&self) -> u8 {
        match self {
            Self::Address(a,_,_,_) => a.get() 
        }
    }
    fn second_octet(&self) -> u8 {
        match self {
            Self::Address(_,b,_,_) => b.get() 
        }
    }
    fn third_octet(&self) -> u8 {
        match self {
            Self::Address(_,_,c,_) => c.get() 
        }
    }
    fn fourth_octet(&self) -> u8 {
        match self {
            Self::Address(_,_,_,d) => d.get() 
        }
    }
    fn get(&self) -> [u8; 4] {
        match self {
            Self::Address(a,b,c,d) => [a.get(), b.get(), c.get(), d.get()] 
        }
    }
    #[allow(dead_code)]
    fn get_octet(&self, index: u8) -> u8 {
        match index {
            1 => self.first_octet(),
            2 => self.second_octet(),
            3 => self.third_octet(),
            4 => self.fourth_octet(),
            _ => panic!("Invalid index"),
        }
    }
    #[allow(dead_code)]
    fn to_string(&self) -> String {
        let mut s = String::new();
        let dot = String::from(".");
        for x in 0..3 {
            s += &self.get()[x].to_string();
            s += &dot;
        }
        s += &self.get()[3].to_string();
        s
    }
}

impl PartialEq for IPv4 {
    fn eq(&self, other: &Self) -> bool {
        self.get() == other.get()
    }
}

impl Display for IPv4 {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        match self {
            Self::Address(a,b,c,d) => write!(f, "{}.{}.{}.{}", a,b,c,d), 
        }
    }
}
