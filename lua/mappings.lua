-- Key Mappings
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- Custom key bindings for navigation, editing, and plugin commands

local keymap = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opts = { noremap = true, silent = true }

-- Keep Space acting as leader
keymap({ "n", "v" }, "<Space>", "<Leader>", { remap = true })

-- Wrapped-line movement
keymap("n", "j", "gj", opts)
keymap("n", "gj", "j", opts)
keymap("n", "k", "gk", opts)
keymap("n", "gk", "k", opts)
keymap("n", "gA", "g$a", opts)

-- Window movement
keymap("n", "<C-j>", "<C-W>j", opts)
keymap("n", "<C-k>", "<C-W>k", opts)
keymap("n", "<C-h>", "<C-W>h", opts)
keymap("n", "<C-l>", "<C-W>l", opts)

-- Vertical split tag/file jumps
keymap("n", "<C-W><C-V>f", ':exec "vert norm <C-V><C-W>f"<CR>', opts)
keymap("n", "<C-W><C-V>[", ':exec "vert norm <C-V><C-W>["<CR>', opts)
keymap("n", "<C-S-]>", ":vert tag <C-R><C-W><CR>", opts)

-- Make mf create/edit file under cursor
keymap("n", "mf", ":e <cword><CR>", { remap = true, silent = true })

-- Jump between braces
keymap({ "n", "v", "o" }, "<C-f>", "f}", { noremap = true })
keymap({ "n", "v", "o" }, "<C-b>", "F{", { noremap = true })
keymap("i", "<C-f>", "<Esc>f}i", opts)
keymap("i", "<C-b>", "<Esc>F{a", opts)

-- Tags
keymap("n", "<leader>]", ":tn<CR>", opts)
keymap("n", "<leader>[", ":tp<CR>", opts)

-- Tagbar moved from <leader>t to avoid conflict with :Tags
keymap("n", "<leader>T", ":TagbarOpenAutoClose<CR>", opts)

-- Search and replace word under cursor
keymap("n", "<Leader>s", ":%s/\\<<C-r><C-w>\\>/", { noremap = true })

-- FZF / fuzzy finder
keymap("n", "<Leader>t", ":Tags<CR>", opts)
keymap("n", "<Leader>l", ":BLines<CR>", opts)
keymap("n", "<Leader>b", ":Buffers<CR>", opts)
keymap("n", "<Leader>f", ":Files<CR>", opts)
keymap("n", "<Leader>g", ":GitFiles<CR>", opts)
keymap("n", "<Leader>r", ":RG<CR>", opts)
keymap("n", "<Leader>h", ":History<CR>", opts)

-- Spell check
keymap("n", "<leader>o", ":setlocal spell! spelllang=en_gb<CR>", { remap = true, silent = true })

-- Change between underscores
keymap("n", "ci_", "T_ct_", opts)

-- Next/last text object
_G.NextTextObject = function(motion, dir)
  local c = vim.fn.nr2char(vim.fn.getchar())

  if c == "b" then
    c = "("
  elseif c == "B" then
    c = "{"
  elseif c == "d" then
    c = "["
  end

  vim.cmd("normal! " .. dir .. c .. "v" .. motion .. c)
end

keymap("o", "an", ":<C-U>lua NextTextObject('a', 'f')<CR>", opts)
keymap("x", "an", ":<C-U>lua NextTextObject('a', 'f')<CR>", opts)
keymap("o", "in", ":<C-U>lua NextTextObject('i', 'f')<CR>", opts)
keymap("x", "in", ":<C-U>lua NextTextObject('i', 'f')<CR>", opts)

keymap("o", "al", ":<C-U>lua NextTextObject('a', 'F')<CR>", opts)
keymap("x", "al", ":<C-U>lua NextTextObject('a', 'F')<CR>", opts)
keymap("o", "il", ":<C-U>lua NextTextObject('i', 'F')<CR>", opts)
keymap("x", "il", ":<C-U>lua NextTextObject('i', 'F')<CR>", opts)
