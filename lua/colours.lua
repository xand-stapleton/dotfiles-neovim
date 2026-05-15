-- Appearance settings and colour scheme configuration for Neovim
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- Colour scheme configuration and appearance settings

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

vim.opt.background = "dark"
vim.opt.guifont = "Monaco:h20"

vim.g.gruvbox_material_background = "hard"

vim.cmd.colorscheme("gruvbox-material")
