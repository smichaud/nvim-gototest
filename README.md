# nvim-gototest

A basic Neovim plugin to navigate between test and source files. This is
obviously quite minimal, but it meets my needs. If you find it useful,
please give it a ⭐. If you find any bug or have potential improvement
ideas, please fill a Github issue.

## Setup

Add using your favorite plugin manager. For instance, if you are using
[vim-plug](https://github.com/junegunn/vim-plug), add this line to your
init.vim:

``` vimscript
Plug 'smichaud/nvim-gototest'
```

Then, you must use the setup function…

Using Lua:

``` lua
require("gototest").setup()
```

Using Vimscript

``` vimscript
lua require("gototest").setup()
```

You should now have access to the the `GoToTest` command. There is no
predefined mapping, you can add your own:

Using Lua:

``` lua
vim.api.nvim_set_keymap("n", "<leader>gt", ":call GoToTest()<CR>", {})
```

Using Vimscript

``` vimscript
nnoremap <leader>gt :GoToTest<CR>
```

## Usage

Simply call the `GoToTestToggle` command from a source file or a test
file. If there is no existing configuration for the current project, you
will be prompted with question to create it.

Note: the file extension is a
[lua pattern](https://www.lua.org/pil/20.1.html).

You can remove the current project/path configuration file using
`GoToTestDeleteConfig`. Alternatively, all configuration files are
located in `~/.local/share/nvim/gototest`, where the file name is the
filepath with all slashes replaced by percent signs.

## Testing GoToTest Plugin

Requires [plenary](https://github.com/nvim-lua/plenary.nvim).

Simply run: `nvim --headless -c "PlenaryBustedDirectory lua/"`

Note that this project goal is mostly for me to learn. Therefore it is
not exhaustively tested.
