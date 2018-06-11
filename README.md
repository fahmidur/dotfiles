# Dotfiles

A small collection of of my dotfiles.

## Usage

There is a setup script (*setup.rb*) which should setup everything I need on a new unconfigured machine.
The setup script goes through the **tree** directory mapping each file to a target file on the current machine.
The tree folder has two top level directories:

* Tree
  * \_\_HOME\_\_ -- All files relative to $HOME, the user's home directory
  * \_\_ROOT\_\_ -- All files relative to ROOT

For every file in this tree, a symlink is at the target location to the source file in the dotfiles repo. If a file is already at the target location, the script will make a crude backup of the file.

```bash
./setup.rb
```
