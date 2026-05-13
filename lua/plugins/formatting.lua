-- ============================================================
-- ~/.config/nvim/lua/plugins/formatting.lua
-- conform.nvim handles formatting; mason-conform installs tools.
--
-- Python: ruff (install via: uv tool install ruff)
-- SQL:    pg_format (install via: brew install pgformatter)
-- ============================================================

return {
  -- Install non-LSP tools (formatters, linters) via Mason
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "ruff",         -- Python linter + formatter
          -- pg_format is a gem/brew tool; install via: brew install pgformatter
          -- It isn't in Mason's registry, so we rely on it being on PATH.
        },
        automatic_installation = true,
      })
    end,
  },

  -- conform.nvim: thin, fast formatter runner
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_format" }, -- ruff's built-in formatter (replaces black)
          sql    = { "pg_format"   }, -- requires pgformatter on PATH
          lua    = { "stylua"      }, -- optional; install via: brew install stylua
          json   = { "prettier"    }, -- optional; install via: npm i -g prettier
          yaml   = { "prettier"    },
          markdown = { "prettier"  },
        },

        -- Format on save (comment out if you prefer manual <leader>f)
        format_on_save = {
          timeout_ms   = 500,
          lsp_fallback = true,   -- fall back to LSP formatter if conform can't find one
        },

        -- Formatter-specific options
        formatters = {
          ruff_format = {
            -- ruff reads pyproject.toml / ruff.toml from project root automatically
            prepend_args = { "--line-length", "88" }, -- PEP 8 default; override in pyproject.toml
          },
          pg_format = {
            -- pg_format options; see: pg_format --help
            args = {
              "--keyword-case", "2",   -- uppercase keywords
              "--type-case",    "2",   -- uppercase types
              "--comma-break",         -- newline after each column in SELECT
              "-",                     -- read from stdin
            },
          },
        },
      })
    end,
  },

  -- nvim-lint: async linting (ruff for Python)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        python = { "ruff" },
      }

      -- Run linter on save and when leaving insert mode
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufReadPost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
