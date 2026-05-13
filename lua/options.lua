-- ============================================================
-- ~/.config/nvim/lua/options.lua
-- ============================================================

local opt = vim.opt

-- Line numbers
opt.number         = true
opt.relativenumber = true

-- Indentation (PEP 8 / SQL convention: 4 spaces)
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartindent    = true

-- Search
opt.ignorecase     = true
opt.smartcase      = true   -- override ignorecase when uppercase present
opt.hlsearch       = false  -- don't persist highlights after search

-- Splits open in the natural direction
opt.splitright     = true
opt.splitbelow     = true

-- Appearance
opt.termguicolors  = true
opt.signcolumn     = "yes"  -- always show; prevents layout shift on diagnostics
opt.cursorline     = true
opt.scrolloff      = 8      -- keep 8 lines visible above/below cursor
opt.wrap           = false

-- Files & undo
opt.swapfile       = false
opt.backup         = false
opt.undofile       = true   -- persistent undo across sessions

-- Clipboard: sync with macOS system clipboard
opt.clipboard      = "unnamedplus"

-- Completion behaviour
opt.completeopt    = { "menu", "menuone", "noselect" }

-- Show whitespace characters
opt.list           = true
opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }

-- Reduce update time for faster CursorHold / diagnostic display
opt.updatetime     = 250
opt.timeoutlen     = 300
