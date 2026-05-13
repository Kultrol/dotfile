-- ============================================================
-- ~/.config/nvim/lua/plugins/jupyter.lua
-- Jupyter / notebook support via molten.nvim
--
-- STATUS: DISABLED — set `enabled = true` when you're ready.
--
-- Prerequisites before enabling:
--   uv tool install jupyterlab
--   uv tool install pynvim
--   pip install cairosvg pnglatex plotly kaleido (for image output)
--   :MoltenInit   ← run once inside nvim to connect to a kernel
-- ============================================================

return {
  {
    "benlubas/molten-nvim",
    enabled      = false,   -- ← flip to true when you want Jupyter support
    version      = "^1.0.0",
    build        = ":UpdateRemotePlugins",
    dependencies = { "3rd/image.nvim" }, -- inline image rendering (optional)
    init = function()
      -- Molten configuration lives in init (before plugin loads)
      vim.g.molten_image_provider          = "image.nvim"  -- or "none"
      vim.g.molten_output_win_max_height   = 20
      vim.g.molten_auto_open_output        = true
      vim.g.molten_wrap_output             = true
      vim.g.molten_virt_text_output        = true
      vim.g.molten_virt_lines_off_by_1     = true
    end,
    config = function()
      -- Keymaps (only active when molten is loaded)
      local map = vim.keymap.set

      map("n", "<leader>jI", ":MoltenInit<CR>",               { desc = "Jupyter: Init kernel" })
      map("n", "<leader>je", ":MoltenEvaluateLine<CR>",        { desc = "Jupyter: Eval line" })
      map("v", "<leader>je", ":<C-u>MoltenEvaluateVisual<CR>", { desc = "Jupyter: Eval selection" })
      map("n", "<leader>jr", ":MoltenReevaluateCell<CR>",      { desc = "Jupyter: Re-eval cell" })
      map("n", "<leader>jd", ":MoltenDelete<CR>",              { desc = "Jupyter: Delete cell" })
      map("n", "<leader>jh", ":MoltenHideOutput<CR>",          { desc = "Jupyter: Hide output" })
      map("n", "<leader>js", ":MoltenShowOutput<CR>",          { desc = "Jupyter: Show output" })
    end,
  },
}
