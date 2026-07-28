-- Plugin Configuration
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- Configuration for Tagbar, Vimtex, LuaSnip, and Gutentags plugins

-- Tagbar
vim.g.tagbar_left = 1
vim.g.tagbar_width = math.max(25, math.floor(vim.o.columns / 5))

vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.g.tagbar_width = math.max(25, math.floor(vim.o.columns / 5))
  end,
})

-- Vimtex
vim.g.vimtex_fold_enabled = 0

if vim.fn.has("mac") == 1 then
  vim.g.vimtex_view_method = "skim"
  vim.g.vimtex_view_skim_sync = 1
  vim.g.vimtex_view_skim_activate = 1
else
  vim.g.vimtex_view_method = "zathura"
end

vim.g.tex_flavor = "xelatex"

vim.g.vimtex_compiler_latexmk = {
  executable = "latexmk",
  options = {
    "-xelatex",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}

vim.g.vimtex_quickfix_autoclose_after_keystrokes = 2
vim.g.vimtex_quickfix_open_on_warning = 1

-- LuaSnip
local luasnip = require("luasnip")

luasnip.setup({
  -- Press Tab in visual mode before expanding a snippet to make the
  -- selection available through LS_SELECT_RAW.
  cut_selection_keys = "<Tab>",
})

require("luasnip.loaders.from_lua").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/luasnip" },
})

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if luasnip.expand_or_locally_jumpable() then
    return "<Plug>luasnip-expand-or-jump"
  end
  return "<Tab>"
end, {
  silent = true,
  expr = true,
  remap = true,
})

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if luasnip.locally_jumpable(-1) then
    return "<Plug>luasnip-jump-prev"
  end
  return "<S-Tab>"
end, {
  silent = true,
  expr = true,
  remap = true,
})

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if luasnip.choice_active() then
    return "<Plug>luasnip-next-choice"
  end
  return "<C-E>"
end, {
  silent = true,
  expr = true,
  remap = true,
})

-- Gutentags
vim.g.gutentags_ctags_exclude_dir = {}
