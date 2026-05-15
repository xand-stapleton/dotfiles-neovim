-- Status Line
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- Custom status line display with mode indicator and git branch info

-- Define statusline to avoid vim-airline/powerline/etc.

local modes = {
  ["n"] = "Normal ",
  ["no"] = "N·Operator Pending ",
  ["nov"] = "N·Operator Pending ",
  ["noV"] = "N·Operator Pending ",
  ["no\22"] = "N·Operator Pending ",

  ["v"] = "Visual ",
  ["V"] = "V·Line ",
  ["\22"] = "V·Block ",

  ["s"] = "Select ",
  ["S"] = "S·Line ",
  ["\19"] = "S·Block ",

  ["i"] = "Insert ",
  ["ic"] = "Insert Completion ",
  ["ix"] = "Insert Completion ",

  ["R"] = "Replace ",
  ["Rc"] = "Replace Completion ",
  ["Rv"] = "V·Replace ",
  ["Rx"] = "Replace Completion ",

  ["c"] = "Command ",
  ["cv"] = "Vim Ex ",
  ["ce"] = "Ex ",

  ["r"] = "Prompt ",
  ["rm"] = "More ",
  ["r?"] = "Confirm ",

  ["!"] = "Shell ",
  ["t"] = "Terminal ",
}

function _G.ModeCurrent()
  local mode = vim.api.nvim_get_mode().mode
  return string.upper(modes[mode] or "V·Block ")
end

function _G.GitBranch()
  local file_dir = vim.fn.expand("%:p:h")

  if file_dir == "" then
    file_dir = vim.fn.getcwd()
  end

  local cmd = {
    "git",
    "-C",
    file_dir,
    "rev-parse",
    "--abbrev-ref",
    "HEAD",
  }

  local result = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 or not result[1] or result[1] == "" then
    return ""
  end

  return result[1]
end

function _G.StatuslineGit()
  local branch = _G.GitBranch()

  if branch == "" then
    return ""
  end

  return "  " .. branch .. " "
end

function _G.StatuslineGutentags()
  if vim.fn.exists("*gutentags#statusline") == 1 then
    return vim.fn["gutentags#statusline"]()
  end

  return ""
end

function _G.StatuslineModifiedTime()
  local file = vim.fn.expand("%:p")

  if file == "" then
    return "no file"
  end

  local time = vim.fn.getftime(file)

  if time <= 0 then
    return "no file"
  end

  return vim.fn.strftime("%Y-%m-%d %H:%M:%S", time)
end

vim.o.statusline = table.concat({
  " %{v:lua.ModeCurrent()}",
  "%#PmenuSel#",
  "%{v:lua.StatuslineGit()}",
  "%#LineNr#",
  " %F",
  "%m",
  "%=",
  "%#CursorColumn#",
  " (%{v:lua.StatuslineModifiedTime()})",
  " %y",
  " %{&fileencoding !=# '' ? &fileencoding : &encoding}",
  "[%{&fileformat}]",
  " %p%%",
  " %l:%c",
  " %{v:lua.StatuslineGutentags()}",
  " ",
  "%*",
})
