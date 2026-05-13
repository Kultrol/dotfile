-- ============================================================
-- ~/.config/nvim/lua/plugins/lsp.lua
--
-- Neovim 0.11+ ships a native vim.lsp.config / vim.lsp.enable
-- API. nvim-lspconfig v3 will drop the old require('lspconfig')
-- shim entirely, so we use the new path directly here.
--
-- Mason still handles server installation; mason-lspconfig
-- wires installed servers into vim.lsp.enable().
-- ============================================================

return {
	-- Mason: installs / manages LSP server binaries
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({ ui = { border = "rounded" } })
		end,
	},

	-- mason-lspconfig: tells mason which servers to install and
	-- calls vim.lsp.enable() for each one automatically.
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"pyright", -- Python
					"sqlls", -- SQL
					"lua_ls", -- Lua (for editing this config)
					"yamlls", -- YAML
					"jsonls", -- JSON
				},
				automatic_installation = true,
			})
		end,
	},

	-- nvim-lspconfig: still used for its server default definitions,
	-- but we call vim.lsp.config() (the 0.11 API) rather than
	-- lspconfig.<server>.setup(), which avoids the deprecation warning.
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp", -- capabilities source for nvim-cmp
			{ "folke/neodev.nvim", config = true }, -- Neovim API types for lua_ls
		},
		config = function()
			-- cmp advertises extended snippet / completion capabilities to servers
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- ── Shared on_attach ───────────────────────────────────
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", vim.lsp.buf.definition, "Go to definition")
					map("gD", vim.lsp.buf.declaration, "Go to declaration")
					map("gr", vim.lsp.buf.references, "References")
					map("gI", vim.lsp.buf.implementation, "Go to implementation")
					map("K", vim.lsp.buf.hover, "Hover docs")
					map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
					map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")
					map("<leader>D", vim.lsp.buf.type_definition, "Type definition")
					-- required lazily to avoid load-order crash (lspconfig loads before Telescope)
					map("<leader>ds", function()
						require("telescope.builtin").lsp_document_symbols()
					end, "Document symbols")
					map("<leader>ws", function()
						require("telescope.builtin").lsp_workspace_symbols()
					end, "Workspace symbols")
				end,
			})

			-- ── vim.lsp.config() — the 0.11 native API ─────────────
			-- These blocks replace the old lspconfig.<server>.setup() calls.
			-- mason-lspconfig calls vim.lsp.enable() for each installed server.

			-- Python (pyright)
			-- uv creates .venv in the project root; pyright finds it via venvPath.
			vim.lsp.config("pyright", {
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
							stubPath = "typestubs",
						},
						venvPath = ".",
						venv = ".venv",
					},
				},
				root_dir = function(fname)
					-- Walk up from the current file looking for uv markers first,
					-- then fall back to standard Python project roots.
					local util = require("lspconfig.util")
					return util.root_pattern(
						"uv.lock", -- uv's lockfile — most specific signal
						"pyproject.toml",
						"setup.py",
						"setup.cfg",
						".git"
					)(fname)
				end,
			}) -- SQL (sqlls)
			vim.lsp.config("sqlls", {
				capabilities = capabilities,
				filetypes = { "sql", "mysql" },
			})

			-- Lua (lua_ls) — understands the Neovim API via neodev
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						diagnostics = { globals = { "vim" } },
					},
				},
			})

			-- YAML
			vim.lsp.config("yamlls", { capabilities = capabilities })

			-- JSON
			vim.lsp.config("jsonls", { capabilities = capabilities })

			-- ── Diagnostic display ─────────────────────────────────
			vim.diagnostic.config({
				virtual_text = { prefix = "●" },
				signs = true,
				underline = true,
				severity_sort = true,
				float = { border = "rounded", source = "always" },
				update_in_insert = false,
			})
		end,
	},
}
