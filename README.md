# Installation

```bash
gem install clone_git_file
```

# Description

#### ;tldr

This gem allows you to replace these commands:

1. `mkdir -p ~/dev/author`
2. `cd ~/dev/author`
3. `git clone https://github.com/author/repo`
4. `cd repo`
5. `myeditor file.rb`

with:

`cgf https://github.com/author/repo/file.rb` (assuming you setup the alias below)

#### Long version

This gem will clone the repository containing a file, then open that file in
your chosen editor. If the repository already exists in the specified directory,
any uncommitted changes will be lost (`git reset HEAD --hard` will be run). The
repository will be pulled after resetting, to get the latest changes.

The editor that will be used is specified using the `EDITOR` environment
variable, which allows you to easily override your editor only for this command.

# Usage

At a minimum, you need to specify a target directory:

```bash
TARGET_DIRECTORY=~/dev clone_git_file https://github.com/brandoncc/clone_git_file/blob/master/README.md
```

That will clone this repository to `~/dev/clone_git_file` then open `README.md`
from the `master` branch.

If you want to override your default editor, just add `EDITOR=myeditor` to the
beginning. For example:

```bash
EDITOR=mvim TARGET_DIRECTORY=~/dev clone_git_file https://github.com/brandoncc/clone_git_file/blob/master/README.md
```

### Bonus

* You can also supply the repo url or a repo directory url, and that directory will be opened by your editor
* Setup an alias to make using the gem easy. For example, here is mine (zsh):

    ```bash
    alias cgf="TARGET_DIRECTORY=~/dev EDITOR=mvim clone_git_file $1"
    ```

# Limitations

Github is the only service that is current compatible. I would like to add more
services in the future.
