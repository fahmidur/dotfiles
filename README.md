# Dotfiles

A small collection of some of my dotfiles and a script to aid the synchronization.

There is a setup script (*setup.rb*) which should setup everything I need on a new unconfigured machine.
The setup script goes through the **tree** directory mapping each file to a target file on the current machine.
The tree folder has two top level directories:

* Tree
  * \_\_HOME\_\_ -- All files relative to $HOME, the user's home directory
  * \_\_ROOT\_\_ -- All files relative to ROOT

For every file in this tree, 
a symlink is created at the target location to the source file in the dotfiles repo. 
If a file is already at the target location, the script will make a crude backup of the file.

```bash
./setup.rb
```

The setup script will create a hidden json file in $HOME to keep track of some meta data.
It uses this file to keep track of which symlinks were created. 

During synchronization broken symlinks from past syncs are removed.
