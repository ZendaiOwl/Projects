use std::{fs, io};
use std::path::{Path, PathBuf};
use colored::Colorize;

#[cfg(test)]
mod tests {
    // use super::*;

}

type Paths = Vec<PathBuf>;
type Nodes = Vec<Node>;

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
            depth: x
        }
    }
    pub fn create(path: &str) -> Node {
        let e = Node::get_path(path);
        let d = Node::get_depth(e[0].to_path_buf());
        Node {
            entries: e,
            count: 0,
            depth: d
        }
    }
    pub fn create_from_path_buf(path: &PathBuf) -> Node {
        Node {
            entries: Node::from_path_buf(path),
            count: 0,
            depth: Node::get_depth(path.to_path_buf())
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
        let mut nv = Vec::<PathBuf>::new();
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
    pub fn create(path: &str) -> Tree {
        let mut n = Vec::<Node>::new();
        n.push(Node::create(path));
        let l = n.len();
        Tree {
            nodes: n,
            parent_pattern: Path::new(path).to_path_buf(),
            length: l,
            count: 0
        }
    }
    pub fn can_read(p: &PathBuf) -> bool {
        if Node::is_readable(p) {
            true
        } else {
            false
        }
    }
    pub fn copy(&self) -> Tree {
        Tree {
            nodes: self.get(),
            parent_pattern: self.get_pattern(),
            length: self.nodes.len(),
            count: self.count
        }
    }
    pub fn get(&self) -> Nodes {
        let mut x = Nodes::new();
        for c in &self.nodes {
            x.push(c.copy());
        }
        x
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
    pub fn add_node(&mut self, node: Node) {
        self.nodes.push(node);
        self.length = self.nodes.len();
    }
    pub fn pattern(&self) -> String {
        self.parent_pattern.display().to_string()
    }
    pub fn get_pattern(&self) -> PathBuf {
        let s = self.pattern();
        let p = Path::new(&s);
        let mut x = PathBuf::new();
        x.push(p.to_path_buf());
        x
    }
    pub fn push_nodes(&mut self, n: Node) {
        let pfx = self.pattern();
        for i in n {
            if i.is_dir() {
                if Self::can_read(&i) {
                    println!("{}", i.strip_prefix(&pfx).expect("No such prefix").display().to_string().bright_blue());
                    // self.add_node(Node::create_from_path_buf(&i));
                    self.push_nodes(Node::create_from_path_buf(&i));
                }
            } else if i.is_file() {
                println!("{}", i.strip_prefix(&pfx).expect("No such prefix").display());
            }
        }
    }
    pub fn print(&self) {
        let pfx = self.pattern();
        for nodes in self.copy() {
            for node in nodes {
                if node.is_dir() {
                    println!("{}", node.strip_prefix(&pfx).expect("No such prefix").display().to_string().bright_blue());
                } else {
                    println!("{}", node.strip_prefix(&pfx).expect("No such prefix").display());
                }
            }
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
