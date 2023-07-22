use std::{fs, io};
use std::fs::File;
use std::io::{BufRead};
use std::path::{Path, PathBuf};
use colored::Colorize;

#[cfg(test)]
mod tests {
    // use super::*;

}

/*
 * Formatting
 */
 
pub enum Format<'a> {
    Error(&'a str),
    Info(&'a str),
    Dir(&'a str),
    File(&'a str),
    None(&'a str),
}

impl Format <'_> {
    pub fn get(&self) -> String {
        match self {
            Format::Error(s) => format!("{} {}", "ERROR".red(), s),
            Format::Info(s) => format!("{} {}", "INFO".blue(), s),
            Format::Dir(s) => format!("{}", s.bright_blue()),
            Format::File(s) => format!("{}", s),
            Format::None(s) => format!("{}", s),
        }
    }
    pub fn to_string(&self) -> String {
        match self {
            Format::Error(s) => format!("{}", s),
            Format::Info(s) => format!("{}", s),
            Format::Dir(s) => format!("{}", s),
            Format::File(s) => format!("{}", s),
            Format::None(s) => format!("{}", s),
        }
    }
    pub fn print(&self) {
        match self {
            Format::Error(s) => eprintln!("{} {}", "ERROR".red(), s),
            Format::Info(s) => println!("{} {}", "INFO".blue(), s),
            Format::Dir(s) => println!("{}", s.blue().bold()),
            Format::File(s) => println!("{}", s),
            Format::None(s) => println!("{}", s),
        };
    }
}

pub fn append(f: Format, a: &str) -> String {
    String::from(f.to_string() + a)
}

pub fn error_format(s: &str) -> String {
    Format::Error(s).get()
}

pub fn dir_format(s: &str) -> String {
    Format::Dir(s).get()
}

pub fn file_format(s: &str) -> String {
    Format::File(s).get()
}

pub fn info_format(s: &str) -> String {
    Format::Info(s).get()
}

pub fn print_error(s: &str) {
    Format::Error(s).print();
}

pub fn first_arg_invalid(s: &str) {
    Format::Error(&format!("Invalid first argument: {s}")).print();
    use_args();
}

pub fn use_args() {
    Format::Info("Use: [ ls | list | echo | gr | print | rd | search ]").print();
}

pub fn string_path(file: &str, pattern: &str) -> String {
    Path::new(file).strip_prefix(pattern).expect("No such prefix").display().to_string()
}

pub fn path_string(file: &Path, pattern: &str) -> String {
    Path::new(file).strip_prefix(pattern).expect("No such prefix").display().to_string()
}

pub fn path_buf_string(file: &PathBuf, pattern: &str) -> String {
    Path::new(file).strip_prefix(pattern).expect("No such prefix").display().to_string()
}

/*
 * Binary Tree & Node(s) for directories
 */
 
type VecFiles = Vec<std::fs::File>;
type Paths = Vec<PathBuf>;
type Nodes = Vec<Node>;

pub struct Files {
    paths: Paths,
    files: VecFiles,
    i: usize,
}

impl Files {
    pub fn new() -> Files {
        let p = Paths::new();
        let f = VecFiles::new();
        Files { paths: p, files: f, i: 0 }
    }
    pub fn copy(&self) -> Files {
        let mut p = Paths::new();
        let mut f = VecFiles::new();
        for x in &self.paths {
            p.push(x.to_path_buf());
        }
        for c in &self.files {
            f.push(File::try_clone(c).expect("Unable to clone file"));
        }
        Files { paths: p, files: f, i: 0 }
    }
    pub fn add(&mut self, file: &PathBuf) {
        if Self::can_open_pathbuf(file) {
            let file = File::open(file).expect("Unable to open file");
            self.files.push(file);
        }
    }
    pub fn get_file_paths(&self) -> Paths {
        let mut p = Paths::new();
        for x in &self.paths {
            p.push(x.to_path_buf());
        }
        p
    }
    pub fn can_open_pathbuf(file: &PathBuf) -> bool {
        match File::open(file) {
            Ok(_) => true,
            Err(_) => false,
        }
    }
    pub fn can_open_path(file: &Path) -> bool {
        match File::open(file) {
            Ok(_) => true,
            Err(_) => false,
        }
    }
    pub fn can_open_str(file: &str) -> bool {
        match File::open(file) {
            Ok(_) => true,
            Err(_) => false,
        }
    }
    pub fn read_file(path: &str, mut writer: impl std::io::Write) {
        if Self::can_open_str(path) {
            let file = File::open(path).expect("Unable to open file");
            let buffer = std::io::BufReader::new(file);
            'read_lines: for line in buffer.lines() {
                match line {
                    Ok(line) => {
                        writeln!(writer, "{}", line).expect("Unable to write line");
                    },
                    Err(_) => {
                        Format::Error(&format!("Not a UTF-8 formatted file: {}", path)).print();
                        break 'read_lines;
                    },
                }
            }
        }
    }
}

impl Iterator for Files {
    type Item = PathBuf;
    fn next(&mut self) -> Option<Self::Item> {
        if self.i < self.paths.len() {
            self.i += 1;
            Some(self.paths[self.i-1].to_path_buf())
        } else {
            None
        }
    }
}

pub struct Node {
    entries: Paths,
    count: usize,
    depth: u32,
}

impl Node {
    pub fn new() -> Node {
        let d = Node::get_paths();
        let x = Node::get_depth(std::env::current_dir().expect("Unable to access current directory"));
        Node {
            entries: d,
            count: 0,
            depth: x,
        }
    }
    pub fn new_all() -> Node {
        let d = Node::get_all_paths();
        let x = Node::get_depth(d[0].to_path_buf());
        Node {
            entries: d,
            count: 0,
            depth: x,
        }
    }
    pub fn create(path: &str) -> Node {
        let e = Node::get_path(path);
        let d = Node::get_depth(e[0].to_path_buf());
        Node {
            entries: e,
            count: 0,
            depth: d,
        }
    }
    pub fn create_all(path: &str) -> Node {
        let e = Node::get_all_path(path);
        let d = Node::get_depth(e[0].to_path_buf());
        Node {
            entries: e,
            count: 0,
            depth: d,
        }
    }
    pub fn create_from_path_buf(path: &PathBuf) -> Node {
        Node {
            entries: Node::from_path_buf(path),
            count: 0,
            depth: Node::get_depth(path.to_path_buf()),
        }
    }
    pub fn from_paths(path: Paths) -> Node {
        let depth = Node::get_depth(path[0].to_path_buf());
        Node {
            entries: path,
            count: 0,
            depth: depth,
        }
    }
    pub fn can_open_file(file: &PathBuf) -> bool {
        match File::open(file) {
            Ok(_) => true,
            Err(_) => false,
        }
    }
    pub fn can_open_filepath(file: &str) -> bool {
        match File::open(file) {
            Ok(_) => true,
            Err(_) => false,
        }
    }
    pub fn is_current_dir_readable() -> bool {
        match std::env::current_dir() {
            Ok(_) => true,
            Err(_) => false,
        }
    }
    pub fn is_readable_path(path: &str) -> bool {
        let f = fs::read_dir(path);
        match f {
            Ok(_) => true,
            Err(_) => false,
        }
    }
    pub fn is_readable(path: &PathBuf) -> bool {
        let f = fs::read_dir(path);
        match f {
            Ok(_) => true,
            Err(_) => false,
        }
    }
    pub fn copy(&self) -> Node {
        let mut nv = Paths::new();
        for c in &self.entries {
            nv.push(c.to_path_buf());
        }
        Node {
            entries: nv,
            count: self.count,
            depth: self.depth
        }
    }
    pub fn get_depth(mut path: PathBuf) -> u32 {
        let mut d = 0;
        loop {
            if ! path.pop() {
                break;
            }
            d += 1;
        }
        d
    }
    pub fn get_paths() -> Paths {
        let current_dir = std::env::current_dir().expect("Unable to access current directory");
        let mut f = fs::read_dir(current_dir)
                        .expect("Unable to read current directory")
                        .map(|res| res.map(|e| e.path()))
                        .filter(|p| match p {
                            Ok(entry) => !entry.as_path()
                                                .file_name()
                                                .expect("Not a path")
                                                .to_str()
                                                .expect("Unable to get name")
                                                .starts_with("."),
                            Err(_) => true,
                        })
                        .collect::<Result<Vec<_>, io::Error>>()
                        .expect("No such file or directory");
        f.sort();
        f
    }
    pub fn get_all_paths() -> Paths {
        let current_dir = std::env::current_dir().expect("Unable to access current directory");
        let mut f = fs::read_dir(current_dir)
                        .expect("Unable to read current directory")
                        .map(|res| res.map(|e| e.path()))
                        .collect::<Result<Vec<_>, io::Error>>()
                        .expect("No such file or directory");
        f.sort();
        f
    }
    pub fn get_path(path: &str) -> Paths {
        let mut f = fs::read_dir(path)
                        .expect("Unable to read directory")
                        .map(|res| res.map(|e| e.path()))
                        .filter(|p| match p {
                            Ok(entry) => !entry.as_path()
                                                .file_name()
                                                .expect("Not a path")
                                                .to_str()
                                                .expect("Unable to get name")
                                                .starts_with("."),
                            Err(_) => true,
                        })
                        .collect::<Result<Vec<_>, io::Error>>()
                        .expect("No such file or directory");
        f.sort();
        f
    }
    pub fn get_all_path(path: &str) -> Paths {
        let mut f = fs::read_dir(path)
                        .expect("Unable to read directory")
                        .map(|res| res.map(|e| e.path()))
                        .collect::<Result<Vec<_>, io::Error>>()
                        .expect("No such file or directory");
        f.sort();
        f
    }
    pub fn from_path_buf(path: &PathBuf) -> Paths {
        let mut f = fs::read_dir(path)
                        .expect("Unable to read directory")
                        .map(|res| res.map(|e| e.path()))
                        .filter(|p| match p {
                            Ok(entry) => !entry.as_path()
                                                .file_name()
                                                .expect("Not a path")
                                                .to_str()
                                                .expect("Unable to get name")
                                                .starts_with("."),
                            Err(_) => true,
                        })
                        .collect::<Result<Vec<_>, io::Error>>()
                        .expect("No such file or directory");
        f.sort();
        f
    }
    pub fn print_paths(&self) {
        for x in &self.entries {
            let path = Path::new(&x).to_path_buf();
            let pfx = match path.parent() {
                Some(pfx) => pfx,
                None => &x,
            };
            if x.is_dir() {
                Format::Dir(&x.strip_prefix(&pfx).expect("No such prefix").display().to_string()).print();
            } else if x.is_file() {
                Format::File(&x.strip_prefix(&pfx).expect("No such prefix").display().to_string()).print();
            }
        }
    }
    pub fn read_file(path: &str, mut writer: impl std::io::Write) {
        if Self::can_open_filepath(path) {
            let file = File::open(path).expect("Unable to open file");
            let buffer = std::io::BufReader::new(file);
            'read_lines: for line in buffer.lines() {
                match line {
                    Ok(line) => {
                        writeln!(writer, "{}", line).expect("Unable to write line");
                    },
                    Err(_) => {
                        Format::Error(&format!("Not a UTF-8 formatted file: {}", path)).print();
                        break 'read_lines;
                    },
                }
            }
        }
    }
    pub fn search_file(pattern: &str, path: &PathBuf, mut writer: impl std::io::Write) {
        if Self::can_open_file(path) {
            let name = path.display().to_string();
            let file = File::open(path).expect("Unable to open file");
            let buffer = std::io::BufReader::new(file);
            'read_lines: for line in buffer.lines() {
                match line {
                    Ok(line) => {
                        if line.contains(pattern) {
                            writeln!(writer, "{name}: {}", line.trim_start()).expect("Unable to write line");
                        }
                    },
                    Err(_) => break 'read_lines,
                }
            }
        }
    }
}

impl Iterator for Node {
    type Item = PathBuf;
    fn next(&mut self) -> Option<Self::Item> {
        if self.count < self.entries.len().try_into().unwrap() {
            self.count += 1;
            Some(self.entries[self.count-1].to_path_buf())
        } else {
            None
        }
    }
}

pub struct Tree {
    nodes: Nodes,
    parent_pattern: PathBuf,
    length: usize,
    count: usize,
}

impl Tree {
    pub fn new() -> Tree {
        let curr_dir = std::env::current_dir().expect("Unable to access current directory");
        let mut n = Nodes::new();
        n.push(Node::new());
        let l = n.len();
        Tree {
            nodes: n,
            parent_pattern: curr_dir,
            length: l,
            count: 0
        }
    }
    pub fn new_all() -> Tree {
        let curr_dir = std::env::current_dir().expect("Unable to access current directory");
        let mut n = Nodes::new();
        n.push(Node::new_all());
        let l = n.len();
        Tree {
            nodes: n,
            parent_pattern: curr_dir,
            length: l,
            count: 0
        }
    }
    pub fn create(path: &str) -> Tree {
        let mut n = Nodes::new();
        n.push(Node::create(path));
        let l = n.len();
        Tree {
            nodes: n,
            parent_pattern: Path::new(path).to_path_buf(),
            length: l,
            count: 0
        }
    }
    pub fn create_all(path: &str) -> Tree {
        let mut n = Nodes::new();
        n.push(Node::create_all(path));
        let l = n.len();
        Tree {
            nodes: n,
            parent_pattern: Path::new(path).to_path_buf(),
            length: l,
            count: 0
        }
    }
    pub fn can_open(p: &PathBuf) -> bool {
        if Node::can_open_file(p) {
            true
        } else {
            false
        }
    }
    pub fn can_read(p: &PathBuf) -> bool {
        if Node::is_readable(p) {
            true
        } else {
            false
        }
    }
    pub fn can_read_path(p: &str) -> bool {
        if Node::is_readable_path(p) {
            true
        } else {
            false
        }
    }
    pub fn copy(&self) -> Tree {
        Tree {
            nodes: self.get_nodes(),
            parent_pattern: self.get_pattern(),
            length: self.nodes.len(),
            count: self.count
        }
    }
    pub fn get_nodes(&self) -> Nodes {
        let mut x = Nodes::new();
        for c in &self.nodes {
            x.push(c.copy());
        }
        x
    }
    pub fn get_length(&self) -> usize {
        self.length
    }
    pub fn ref_nodes(&self) -> &Nodes {
        &self.nodes
    }
    pub fn iterate(&mut self) {
        for node in self.copy().nodes {
            for i in node.copy() {
                if i.is_dir() {
                    self.push_nodes(Node::create_from_path_buf(&i));
                }
            }
        }
    }
    pub fn iterate_fast(&mut self) {
        for node in self.copy().nodes {
            for i in node.copy() {
                if i.is_dir() {
                    self.show_nodes(Node::create_from_path_buf(&i));
                }
            }
        }
    }
    pub fn add_node(&mut self, node: Node) {
        self.nodes.push(node);
        self.length = self.nodes.len();
    }
    pub fn pattern(&self) -> String {
        self.parent_pattern.display().to_string()
    }
    pub fn get_pattern(&self) -> PathBuf {
        Path::new(&self.parent_pattern).to_path_buf()
    }
    pub fn push_nodes(&mut self, n: Node) {
        for i in n {
            if i.is_dir() {
                if Self::can_read(&i) {
                    let new_node = Node::create_from_path_buf(&i);
                    self.add_node(new_node.copy());
                    self.push_nodes(new_node);
                }
            }
        }
    }
    pub fn show_nodes(&mut self, n: Node) {
        let pfx = self.pattern();
        for i in n {
            if i.is_dir() {
                if Self::can_read(&i) {
                    self.length += 1;
                    Format::Dir(&i.strip_prefix(&pfx).expect("No such prefix").display().to_string()).print();
                    self.show_nodes(Node::create_from_path_buf(&i));
                }
            } else if i.is_file() {
                Format::File(&i.strip_prefix(&pfx).expect("No such prefix").display().to_string()).print();
            }
        }
    }
    pub fn find_string(&mut self, string_pattern: &str) {
        for nodes in self.copy().nodes {
            for node in nodes.copy() {
                if node.is_dir() {
                    self.search_nodes(Node::create_from_path_buf(&node), string_pattern);
                } else if node.is_file() {
                    self.search_file(string_pattern, &node, std::io::stdout().lock());
                }
            }
        }
    }
    fn search_nodes(&mut self, n: Node, pattern: &str) {
        for i in n {
            if i.is_dir() {
                if Self::can_read(&i) {
                    self.length += 1;
                    self.search_nodes(Node::create_from_path_buf(&i), pattern);
                }
            } else if i.is_file() {
                self.search_file(pattern, &i, std::io::stdout().lock());
            }
        }
    }
    fn search_file(&self, pattern: &str, path: &PathBuf, mut writer: impl std::io::Write) {
        if Self::can_open(path) {
            let pfx = self.pattern();
            let name = path.strip_prefix(&pfx).expect("No such prefix").display().to_string();
            let file = File::open(path).expect("Unable to open file");
            let buffer = std::io::BufReader::new(file);
            'read_lines: for line in buffer.lines() {
                match line {
                    Ok(line) => {
                        if line.contains(pattern) {
                            writeln!(writer, "{}: {}", name.green(), line.trim_start()).expect("Unable to write line");
                        }
                    },
                    Err(_) => break 'read_lines,
                }
            }
        }
    }
    pub fn file_search(pattern: &str, path: &PathBuf, writer: impl std::io::Write) {
        if Self::can_open(path) {
            Node::search_file(pattern, path, writer);
        }
    }
}

impl Iterator for Tree {
    type Item = Node;
    fn next(&mut self) -> Option<Self::Item> {
        if self.count < self.nodes.len() {
            self.count += 1;
            Some(self.nodes[self.count-1].copy())
        } else {
            None
        }
    }
}
