-- Editor Options
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- Core neovim editor settings and defaults

local opt = vim.opt

vim.cmd.syntax("on")
vim.cmd("filetype plugin indent on")

opt.number = true
opt.autochdir = true
opt.autoindent = true
opt.ignorecase = true
opt.smartcase = true
opt.backspace = { "indent", "eol", "start" }
opt.smarttab = true
opt.showtabline = 1
opt.mouse = "n"

opt.splitbelow = true
opt.splitright = true

opt.laststatus = 2
opt.showmode = false

opt.wildmode = { "longest", "list", "full" }
