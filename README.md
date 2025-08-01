# nvim
This is my custom Neovim configuration. I took ideas from all over the internet to piece it together. Feel free to use, reference, take whatever parts of it you want for your own configuration.

I prefer a minimal setup, so there are only a handful of plugins added. I use the [Lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager to manage them.

The majority of my config is in `init.lua`. I have copied several [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) configs, which I use as a starting point. These configs can be found in the `lsp` directory. I overwrite some of their options in `init.lua`.

If you would like to use this repository as a jumping point, the easiest way to do this would be to fork this repository, modify the lua configs to your liking, and clone your fork into your Neovim config directory. By default, Neovim config directories are `~/.config` on Unix like systems and `~/AppData/Local` on Windows systems.
