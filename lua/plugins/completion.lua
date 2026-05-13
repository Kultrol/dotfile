-- ============================================================
-- ~/.config/nvim/lua/plugins/completion.lua
-- nvim-cmp: completion engine
-- LuaSnip:  snippet engine (also provides friendly-snippets)
-- ============================================================

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP completions
      "hrsh7th/cmp-buffer",      -- words from current buffer
      "hrsh7th/cmp-path",        -- filesystem paths
      "hrsh7th/cmp-cmdline",     -- command-line completion
      "saadparwaiz1/cmp_luasnip",-- LuaSnip source for cmp
      {
        "L3MON4D3/LuaSnip",
        version      = "v2.*",
        build        = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config       = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),

          -- Confirm: <CR> selects, Tab cycles
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750  },
          { name = "buffer",   priority = 500  },
          { name = "path",     priority = 250  },
        }),

        -- Nicer completion menu formatting
        formatting = {
          format = function(entry, item)
            local source_icons = {
              nvim_lsp = "[LSP]",
              luasnip  = "[Snip]",
              buffer   = "[Buf]",
              path     = "[Path]",
            }
            item.menu = source_icons[entry.source.name] or ""
            return item
          end,
        },
      })

      -- Command-line / completion
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })

      -- Autopairs integration: confirm completion closes pair correctly
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
