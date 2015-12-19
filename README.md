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

`ogf https://github.com/author/repo/file.rb` (if you choose to setup an alias)

#### Long version

This gem will clone the repository containing a file, optionally opening that
file in your chosen editor. If the repository already exists in the specified
directory, any uncommitted changes will be lost (`git reset HEAD --hard` will
be run). The repository will be pulled after resetting, to get the latest
changes.

The editor that will be used is specified using the `EDITOR` environment
variable, which allows you to easily override your editor only for this command.

# Usage

At a minimum, you need to specify a target directory and url:

```bash
TARGET_DIRECTORY=~/dev clone_git_file https://github.com/brandoncc/clone_git_file/blob/master/README.md
```

That will clone this repository to `~/dev/clone_git_file`, then switch to the
`master` branch. A message will then be shown giving you that location.

There are command switches available as follows:

| Switch | Description |
| --- | --- |
| -o, <nobr>--open</nobr> | Open the file in the specified editor after cloning |
| -t, <nobr>--terminal</nobr> | Output the command which would be used to open the file in your editor, as text in the terminal. This is useful for piping into other commands. Since Ruby `system` method executions are run in a child process, this is useful for opening the file in your editor in the current shell (more details in the bonus section). This is equivalent to `-ot`. |
| -s, <nobr>--silent</nobr> | Suppress messages from the cloning process. If you want to pipe the output of `-t` into a command, you should also use this. |

If you want to override your default editor, just add `EDITOR=myeditor` to the
beginning. For example:

```bash
EDITOR=mvim TARGET_DIRECTORY=~/dev clone_git_file https://github.com/brandoncc/clone_git_file/blob/master/README.md
```

### Bonus

* You can also supply the repo url or a repo subdirectory url, and that directory will be opened by your editor.
* Setup an alias and/or function to make using the gem easy. For example, here are mine (zsh):

    ```bash
    alias cgf="TARGET_DIRECTORY=~/dev EDITOR=mvim clone_git_file $1"

    function ogf () {
      echo "Cloning, your editor will open when clone has completed..."
      source <(TARGET_DIRECTORY=~/dev EDITOR=mvim clone_git_file -ts $1)
    }
    ```
    
    `cgf` clones, then prints a message with the location of the cloned
    file/directory.
    
    `ogf` prints the commands to open the file/directory in my editor. I then
    use `source <(...)` to pipe the printed command to `source` which runs it
    in my current shell. This fixes some weird things that happen when opening
    the editor in a child process, and also allows the current directory of my
    current shell to be changed (instead of the child process shell which will
    be lost when you close the editor).
    
    `ogf` has to be a function so that `$1` will expand properly. If you use an
    alias instead, `$1` doesn't hold the correct value in the nested command.

# Limitations

* Github is the only service that is currently compatible. I would like to add more services in the future.
* `-s, --silent` is only available on operating systems which can direct output to `/dev/null`, which means it is unavailable on Windows.
