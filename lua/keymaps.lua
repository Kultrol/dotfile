-- ============================================================
-- ~/.config/nvim/lua/keymaps.lua
-- ============================================================

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- ── Window navigation ────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })

-- ── Buffer navigation ────────────────────────────────────────
map("n", "<S-h>", ":bprevious<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", ":bnext<CR>",     { desc = "Next buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- ── File tree (neo-tree) ─────────────────────────────────────
map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle file tree" })

-- ── Telescope ────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",  { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",   { desc = "Live grep (rg)" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",     { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",   { desc = "Help tags" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })

-- ── LSP (set inside lsp on_attach, but global fallbacks here) ─
map("n", "<leader>q",  vim.diagnostic.setloclist,        { desc = "Quickfix diagnostics" })
map("n", "[d",         vim.diagnostic.goto_prev,          { desc = "Prev diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next,          { desc = "Next diagnostic" })

-- ── Formatting ───────────────────────────────────────────────
map({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer / selection" })

-- ── Quality of life ──────────────────────────────────────────
-- Keep visual selection when indenting
map("v", "<", "<gv", { desc = "Indent left, keep selection" })
map("v", ">", ">gv", { desc = "Indent right, keep selection" })

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Clear search highlight
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Save with Ctrl-S (muscle memory from other editors)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })
