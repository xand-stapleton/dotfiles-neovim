-- Tab Line
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- Custom tab line display and navigation

_G.MyTabLabel = function(n)
  local tabnum = n
  local buflist = vim.fn.tabpagebuflist(n)
  local winnr = vim.fn.tabpagewinnr(n)
  local bufnr = buflist[winnr]
  local bufname = vim.fn.bufname(bufnr)

  if bufname == nil or bufname == "" then
    bufname = "[No Name]"
  else
    bufname = vim.fn.fnamemodify(bufname, ":t")
  end

  local win_count = vim.fn.tabpagewinnr(n, "$")
  local split_marker = win_count > 1 and " (sp)" or ""

  return string.format("%d: %s%s", tabnum, bufname, split_marker)
end

_G.MyTabLine = function()
  local s = ""

  for i = 1, vim.fn.tabpagenr("$") do
    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    s = s .. "%" .. i .. "T"
    s = s .. " " .. _G.MyTabLabel(i) .. " "
  end

  s = s .. "%#TabLineFill#%T"
  return s
end

vim.opt.tabline = "%!v:lua.MyTabLine()"
