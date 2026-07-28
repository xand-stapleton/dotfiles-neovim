-- Language-Specific Settings
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- Configuration for Python, C, TeX, Fortran and other language types

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set

-- Python / C / headers
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.py", "*.pyw" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.py", "*.pyw", "*.c", "*.h" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.colorcolumn = "79"
    vim.opt_local.cursorcolumn = true
    vim.opt_local.cursorline = true
  end,
})

-- -- Python word movement around underscores
-- autocmd("FileType", {
--   pattern = "python",
--   callback = function()
--     vim.opt_local.iskeyword:append("^_")
--   end,
-- })


-- Fortran tab highlight
vim.g.fortran_have_tabs = 1

-- TeX wrapping
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.tex",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- -- Wrapped movement on Python files
-- autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = { "*.py", "*.pyw" },
--   callback = function()
--     vim.opt_local.whichwrap:append({ "<", ">", "h", "l" })
  -- end,
-- })

-- Ruff
local python_ruff = augroup("PythonRuff", { clear = true })

autocmd("FileType", {
  group = python_ruff,
  pattern = "python",
  callback = function()
    keymap("n", "<Leader>p", ":!ruff format %<CR>", { buffer = true, noremap = true })
    keymap("n", "<Leader>i", ":!ruff check --select I % --fix<CR>", { buffer = true, noremap = true })
  end,
})

-- Go formatting
local gofmt = augroup("GoFmt", { clear = true })

autocmd("FileType", {
  group = gofmt,
  pattern = "go",
  callback = function()
    keymap("n", "<Leader>p", ":!go fmt %<CR>", { buffer = true, noremap = true })
    keymap("n", "<Leader>i", ":!goimports -w %<CR>", { buffer = true, noremap = true })
  end,
})

local go_imports = augroup("go_imports", { clear = true })

autocmd("BufWritePost", {
  group = go_imports,
  pattern = "*.go",
  callback = function()
    vim.cmd("silent! !goimports -w " .. vim.fn.shellescape(vim.fn.expand("<afile>")))
  end,
})
