-- ============================================================
-- ~/.config/nvim/lua/plugins/init.lua
-- lazy.nvim bootstrap + top-level plugin declarations
-- ============================================================

-- ── Bootstrap lazy.nvim ──────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugin spec ──────────────────────────────────────────────
require("lazy").setup({

  -- ── Colorscheme ──────────────────────────────────────────
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,   -- load before everything else
    config   = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ── Status line ──────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "catppuccin" },
        sections = {
          lualine_x = { "filetype", "encoding" },
        },
      })
    end,
  },

  -- ── File tree ────────────────────────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch       = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = { hide_dotfiles = false },
        },
      })
    end,
  },

  -- ── Which-key: shows available keybindings ────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({})
    end,
  },

  -- ── Autopairs ────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = true,
  },

  -- ── Comment toggle ───────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    config = true,
  },

  -- ── Git signs in the gutter ──────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
      })
    end,
  },

  -- ── Indent guides ────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main   = "ibl",
    config = true,
  },

  -- ── Core plugin modules (loaded via separate files) ──────
  { import = "plugins.treesitter"  },
  { import = "plugins.telescope"   },
  { import = "plugins.lsp"         },
  { import = "plugins.completion"  },
  { import = "plugins.formatting"  },
  { import = "plugins.jupyter"     },

}, {
  -- lazy.nvim UI options
  ui = { border = "rounded" },
  checker = { enabled = true, notify = false }, -- auto-check for plugin updates
})
