-- Custom Commands
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- User-defined custom commands for common operations

-- DiffOrig, from Vim defaults
if vim.fn.exists(":DiffOrig") == 0 then
  vim.api.nvim_create_user_command("DiffOrig", function()
    vim.cmd([[
      vert new
      set bt=nofile
      r ++edit #
      0d_
      diffthis
      wincmd p
      diffthis
    ]])
  end, {})
end

-- Fix :Q and :W
vim.api.nvim_create_user_command("Q", "q", { bang = true })
vim.api.nvim_create_user_command("W", "w", { bang = true })

-- Fugitive shortcut
vim.api.nvim_create_user_command("GV", "vert G", {})

-- Insert comma-separated list of files from a directory
vim.api.nvim_create_user_command("InsertFileList", function(opts)
  local dir = opts.args
  local pattern = dir .. "/*"
  local files = vim.fn.glob(pattern, false, true)

  if vim.tbl_isempty(files) then
    print("No files found in " .. dir)
    return
  end

  local joined = table.concat(files, ",")
  vim.fn.append(vim.fn.line("."), joined)
end, {
  nargs = 1,
})
