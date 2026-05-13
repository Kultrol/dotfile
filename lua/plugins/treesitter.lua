-- ============================================================
-- ~/.config/nvim/lua/plugins/treesitter.lua
-- ============================================================

return {
	{
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.9.3", -- last stable release before v1 API break
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects", -- af/if, ac/ic etc.
		},
		-- `main` tells lazy.nvim which module to call .setup() on,
		-- replacing the explicit config function. This is the correct
		-- pattern for nvim-treesitter v1.0+ which dropped the .configs submodule.
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"python",
				"sql",
				"lua",
				"vim",
				"vimdoc",
				"json",
				"yaml",
				"toml",
				"markdown",
				"markdown_inline",
				"bash",
			},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },

			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
					goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
				},
			},
		},
	},
}
