-- Neovim Configuration
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- Main entry point that loads all configuration modules
-- require('vim._core.ui2').enable()
require("options")
require("packages")
require("statusline")
require("completion")
require("tabline")
require("commands")
require("autocmds")
require("mappings")
require("languages")
require("plugins")
require("appearance")

vim.opt.breakindentopt = { 'shift:4', 'sbr' }
vim.opt.breakat = ' \t;:,!?'

vim.filetype.add {
  extension = {
    tmpl = 'gotmpl',
  },
}

-- vim.cmd([[
-- set runtimepath^=~/.vim runtimepath+=~/.vim/after
-- let &packpath = &runtimepath
-- source ~/.vimrc
-- ]])
