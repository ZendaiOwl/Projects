___Git___

_Random information about Git I've found and gathered_

* TOC
{:toc}

---

# Commit message

_Conventional Git commit message structure_

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

# Git Subtree

Check existing subtree's in a repository

```bash
git log | grep 'git-subtree-dir' | awk '{ print $2 }' | sort | uniq
```

Number of git subtree's in a repository

```bash
git log | grep 'git-subtree-dir' | awk '{ print $2 }' | sort | uniq | wc -l
```

# Resources

+ **§** [_Conventional commits_](https://www.conventionalcommits.org/en/v1.0.0/)
+ **§** [_Conventional commits - Specification_](https://www.conventionalcommits.org/en/v1.0.0/#specification)

---

