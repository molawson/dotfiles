# Dot Files

These are config files to set up a system the way I like it. It includes configuration for vim, zsh, git, Ruby gems, OSX, and others.

I am running on Mac OS X, but it will likely work on Linux as well.

## Before you start

These dot files are just a piece of the puzzle that makes up my computer setup.  If you want to know more about how my dot files interact with the rest of my system and the other tools I use, take a look at [this gist](https://gist.github.com/2402229) that I use when setting up a new machine.

The installation instructions below don't include installing vim plugins or running other related tasks.


## Installation

Run the following commands in your terminal. It will prompt you before it does anything destructive. Check out the [Rakefile](https://github.com/molawson/dotfiles/blob/master/Rakefile) to see exactly what it does.

```terminal
git clone git://github.com/molawson/dotfiles ~/.dotfiles
cd ~/.dotfiles
rake install
```
**NB:** Please update the gitconfig file to use your name and email rather than my own.

After installing, open a new terminal window to see the effects.

Feel free to customize the .zshrc file to match your preference.

For more info on installing the vim plugins and other pieces related to these dot files, take a look at [this gist](https://gist.github.com/2402229) that I use when setting up a new machine.

----

** This Readme and Rakefile were copied from Ryan Bates' [dotfiles](https://github.com/ryanb/dotfiles) and customized for my setup.
