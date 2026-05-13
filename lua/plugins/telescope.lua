-- ============================================================
-- ~/.config/nvim/lua/plugins/telescope.lua
-- ============================================================

return {
  {
    "nvim-telescope/telescope.nvim",
    branch       = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Native fzf sorter — significantly faster for large repos
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          -- rg is available; use it for live_grep
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading",
            "--with-filename", "--line-number",
            "--column", "--smart-case", "--hidden",
            "--glob", "!**/.git/*",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
            },
          },
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
        },
        pickers = {
          find_files = {
            -- include hidden files, exclude .git
            hidden         = true,
            find_command   = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      })

      telescope.load_extension("fzf")
    end,
  },
}
