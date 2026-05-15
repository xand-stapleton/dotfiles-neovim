# Neovim Configuration

Copyright (c) Alexander Stapleton 2026. All rights reserved.

A modern Neovim configuration featuring LSP-based code completion, custom key bindings, language-specific settings, and a curated collection of plugins.

## Overview

This configuration provides:
- **LSP Integration**: Modern code completion and diagnostics via nvim-lspconfig
- **Plugin Management**: Via vim.pack with plugins including vim-fugitive, fzf.vim, vimtex, and more
- **Language Support**: Specialized settings for Python, C/C++, TeX, Fortran, and Go
- **Custom UI**: Custom status line and tab line without external dependencies
- **Snippets**: UltiSnips integration with ready-to-use templates for multiple languages

## File Structure

### Core Configuration
- **init.lua** - Main entry point that loads all configuration modules

### Configuration Modules (lua/)
- **options.lua** - Core editor settings (line numbers, indentation, splits, mouse support)
- **packages.lua** - External packages and plugins installed via vim.pack
- **mappings.lua** - Custom key bindings for navigation, editing, and plugin commands
- **commands.lua** - User-defined custom commands (e.g., `:DiffOrig`, `:GV`)
- **completion.lua** - LSP-based code completion and diagnostic configuration
- **colours.lua** - Color scheme (gruvbox-material) and appearance settings
- **autocmds.lua** - Automatic commands for relative line numbers, fold preservation, and TODO highlighting
- **languages.lua** - Language-specific settings for Python, C, TeX, Fortran, Go, and more
- **plugins.lua** - Configuration for Tagbar, Vimtex, UltiSnips, and Gutentags plugins
- **statusline.lua** - Custom status line with mode indicator, git branch, and file info
- **tabline.lua** - Custom tab line display and navigation

### Snippets (UltiSnips/)
- **go.snippets** - Go language code templates
- **markdown.snippets** - Markdown document snippets
- **tex.snippets** - LaTeX document snippets

## Key Features

### Installed Plugins
- vim-eunuch - Unix file operations
- vim-solarized8 & gruvbox-material - Color schemes
- vim-surround - Surround text objects
- vim-fugitive - Git integration
- nvim-lspconfig - LSP client configuration
- tagbar - Symbol browser
- fzf.vim - Fuzzy finder
- ultisnips - Snippet engine
- vim-polyglot - Language syntax support
- vimtex - LaTeX support
- vim-commentary - Comment toggling
- vim-unimpaired - Bracket mappings

### Explicit language modifications
- **Python** - 4-space indentation, column/cursor guides, Ruff formatting & import sorting
- **C/C++** - 4-space indentation, 79-char column guide
- **TeX/LaTeX** - Soft wrapping, xelatex compilation via latexmk, Skim viewer (macOS)
- **Go** - Template snippets, custom filetypes (.tmpl)
- **Fortran** - Tab character highlighting

### Custom Key Bindings

**Leader Key**: `<Space>`

#### Navigation
- `j/k` - Move by visual lines (wrapped line aware)
- `gj/gk` - Move by actual lines
- `<C-j/k/h/l>` - Window navigation
- `<C-f>` - Jump to next closing brace `}`
- `<C-b>` - Jump to previous opening brace `{`
- `gA` - Go to end of line in append mode

#### File & Tag Operations
- `mf` - Create or edit file under cursor
- `<C-W><C-V>f` - Open file under cursor in vertical split
- `<C-W><C-V>[` - Jump to tag in vertical split
- `<C-S-]>` - Jump to tag definition in vertical split
- `<Leader>[` - Previous tag
- `<Leader>]` - Next tag

#### Fuzzy Finder (fzf)
- `<Leader>t` - Search tags
- `<Leader>l` - Search current buffer lines
- `<Leader>b` - Search open buffers
- `<Leader>f` - Search files in current directory
- `<Leader>g` - Search git files
- `<Leader>r` - Search with ripgrep

#### Plugin Commands
- `<Leader>T` - Toggle Tagbar symbol browser
- `<Leader>s` - Search and replace word under cursor
- `<Leader>o` - Toggle spell check (en_gb)

#### Text Objects & Selection
- `ci_` - Change inside underscores
- `an/in` - Next text object (after/inside)
- `al/il` - Last text object (after/inside)

## Requirements

- Neovim (0.12.0+)
- Git (for fugitive)
- ctags/Universal Ctags (for tagbar)
- ruff (Python linter and formatter)
- LaTeX distribution (for vimtex)
- fzf (for fuzzy finding)

## Installation

1. Clone or link this directory to `~/.config/nvim/`
2. Start Neovim - plugins will be installed automatically via vim.pack
3. Install language servers for LSP support via `:LspInstall`

## Color Scheme

Default color scheme is **gruvbox-material** with dark background (hard contrast mode).

To change:
1. Edit `lua/colours.lua`
2. Update the `vim.cmd.colorscheme()` call or install alternative schemes

## Customization

Each module is self-contained and can be customized independently:
- Modify `lua/options.lua` for editor preferences
- Add mappings in `lua/mappings.lua`
- Configure plugins in `lua/plugins.lua`
- Add language-specific settings in `lua/languages.lua`

## Notes

- Relative line numbers toggle automatically when entering/leaving insert mode
- Folds are preserved across sessions via `mkview`
- Git branch is displayed in the status line when in a repository
