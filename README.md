# dotfiles

My configuration files for vim and zsh.

## Requirements

* `zsh`
  * Install with `apt-get install zsh` (or a similiar command, depending on your system)
  * Set as default shell: `chsh -s $(which zsh)`
* To use the [YCM-plugin](https://github.com/Valloric/YouCompleteMe)
  * `apt-get install build-essentials python-dev`
  * With support for the C-family languages:
    * `apt-get install clang`

## Installation

* Clone the project and all the submodules:
  `git clone --recursive https://github.com/okpedersen/dotfiles.git`
* Copy the needed files to the home directory:
  ```zsh
  cd dotfiles
  zsh update.sh
  ```
* To use the [YCM-plugin](https://github.com/Valloric/YouCompleteMe)
  ```zsh
  cd ~/.vim/bundle/YouCompleteMe
  
  # with support for C-family languages:
  ./install.sh --clang-completer
  
  # without support for C-family languages:
  ./install.sh
  ```

## License

The software is licensed under the MIT License. Please see [LICENSE](LICENSE)
