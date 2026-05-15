-- Automatic Commands
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- Autocommands for relative line numbers, fold preservation, and syntax highlighting

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Sensible line numbers
local numbertoggle = augroup("numbertoggle", { clear = true })

autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = numbertoggle,
  callback = function()
    vim.opt_local.relativenumber = true
  end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = numbertoggle,
  callback = function()
    vim.opt_local.relativenumber = false
  end,
})

-- Remember folds
local remember_folds = augroup("remember_folds", { clear = true })

autocmd("BufWinLeave", {
  group = remember_folds,
  command = "silent! mkview",
})

autocmd("BufWinEnter", {
  group = remember_folds,
  command = "silent! loadview",
})

-- Highlight TODO-style comments
local vimrc_todo = augroup("vimrc_todo", { clear = true })

autocmd("Syntax", {
  group = vimrc_todo,
  command = [[syntax match CustomTodo /\v<(FIXME|NOTE|TODO|OPTIMIZE|XXX|WARNING|PROBLEM|ERROR):/ containedin=.*Comment,vimCommentTitle]],
})

vim.cmd("highlight default link CustomTodo Todo")

-- Disable automatic commenting on newline
autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Disable tag generation during Git commit/rebase
local git_commit_rebase = augroup("GitCommitRebase", { clear = true })

autocmd({ "BufRead", "BufNewFile" }, {
  group = git_commit_rebase,
  pattern = "*",
  callback = function()
    local filename = vim.fn.expand("%:t")
    local path = vim.fn.expand("%:p")

    if filename:match("^COMMIT_EDITMSG")
      or filename:match("^MERGE_MSG")
      or filename:match("^TAG_EDITMSG$")
      or path:match("/%.git/rebase%-")
    then
      vim.opt_local.tags = ""
    end
  end,
})
