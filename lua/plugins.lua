-- Plugin Configuration
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- Configuration for Tagbar, Vimtex, UltiSnips, and Gutentags plugins

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

-- UltiSnips
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
vim.g.UltiSnipsEditSplit = "vertical"

-- Gutentags
vim.g.gutentags_ctags_exclude_dir = {}
