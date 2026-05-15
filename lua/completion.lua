-- Code Completion
-- Copyright (c) Alexander Stapleton 2026. All rights reserved.
-- LSP-based code completion and diagnostic configuration

vim.opt.completeopt = "menu,menuone,noselect,popup,fuzzy" -- Ensures the menu appears even for a single match and uses the native popup window.
vim.o.autocomplete = true -- Enables the overall completion feature.
-- The 'complete' option specifies the sources for completion. 'o' includes
-- omni-completion (LSP), and 'f' includes file name completion.
vim.opt.complete = { 'o', 'f' }

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
    callback = function(args)
      local client_id = args.data.client_id
      if not client_id then
        return
      end

      local client = vim.lsp.get_client_by_id(client_id)
      if client and client:supports_method("textDocument/completion") then
        -- Enable native LSP completion for this client + buffer
        vim.lsp.completion.enable(true, client_id, args.buf, {
            autotrigger = true,   -- auto-show menu as you type (recommended)
            -- You can also set { autotrigger = false } and trigger manually with <C-x><C-o>
          })
      end
    end,
  })

vim.o.pumborder = 'rounded'
vim.o.pummaxwidth = 40

-- Diagnostics mappings
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)

local lsp_flags = {
  debounce_text_changes = 150,
}

local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.api.nvim_set_option_value(
    'omnifunc',
    'v:lua.vim.lsp.omnifunc',
    { buf = 0 }
    )

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>f', function()
  vim.lsp.buf.format({ async = true })
end, bufopts)
end


-- Shared config for every LSP server
vim.lsp.config('*', {
    on_attach = on_attach,
    flags = lsp_flags,
  })

-- Pyright
vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
  })

-- Go: gopls
vim.lsp.config('gopls', {
    cmd = { 'gopls' },
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  })

-- LaTeX: texlab
vim.lsp.config('texlab', {
    cmd = { 'texlab' },
  })

-- Start the servers
vim.lsp.enable({
    'pyright',
    'gopls',
    'texlab',
  })
