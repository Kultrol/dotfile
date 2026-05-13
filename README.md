# Neovim Config — Setup & Reference

## Installation

```bash
# Back up any existing config first
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

# Copy this config into place
cp -r /path/to/this/nvim-config ~/.config/nvim

# Open Neovim — lazy.nvim will bootstrap itself and install all plugins
nvim
```

On first launch, lazy.nvim clones itself and then installs every plugin.
Mason then installs the LSP servers. This takes ~1–2 minutes on first run.
Press `q` to close the lazy UI once it finishes.

---

## Dependencies to install via Homebrew

```bash
brew install ripgrep          # already installed — used by Telescope live_grep
brew install pgformatter      # pg_format: SQL formatter
brew install stylua           # Lua formatter (optional, for editing this config)
brew install node             # needed by some LSP servers (jsonls, yamlls)
```

---

## Python workflow with uv

This config points pyright at `.venv` in your project root, which is where
`uv` creates virtual environments by default.

```bash
# Create a new project
uv init my-project && cd my-project

# Add dependencies
uv add pandas polars sqlalchemy psycopg2-binary

# Install ruff globally as a tool (formatter + linter)
uv tool install ruff

# Launch nvim from the project root — pyright will find .venv automatically
nvim .
```

If pyright isn't picking up your venv, activate it before launching nvim:

```bash
source .venv/bin/activate && nvim .
```

Or set `VIRTUAL_ENV` explicitly:

```bash
VIRTUAL_ENV=$(pwd)/.venv nvim .
```

---

## SQL / PostgreSQL (sqlls)

`sqlls` works best with a config file that tells it your connection details.
Create `~/.config/sqlls/config.yml`:

```yaml
connections:
  - name: local_postgres
    driver: postgresql
    dataSourceName: "host=localhost port=5432 user=YOUR_USER dbname=YOUR_DB sslmode=disable"
    projectPaths:
      - /path/to/your/sql/project
```

Then in `lua/plugins/lsp.lua`, uncomment the `cmd` line in `sqlls.setup` and
point it at this file.

---

## Key bindings reference

| Key            | Action                         |
|----------------|-------------------------------|
| `<leader>ff`   | Find files (Telescope)        |
| `<leader>fg`   | Live grep with rg             |
| `<leader>fb`   | Switch buffers                |
| `<leader>fd`   | Browse diagnostics            |
| `<leader>e`    | Toggle file tree (neo-tree)   |
| `<leader>f`    | Format buffer / selection     |
| `<leader>ca`   | Code action (LSP)             |
| `<leader>rn`   | Rename symbol (LSP)           |
| `gd`           | Go to definition              |
| `gr`           | References                    |
| `K`            | Hover docs                    |
| `[d` / `]d`    | Prev / next diagnostic        |
| `<C-s>`        | Save                          |

`<leader>` is Space.

---

## Enabling Jupyter support

When you're ready:

1. Install the kernel and Python bridge:
   ```bash
   uv tool install jupyterlab
   pip install pynvim cairosvg
   ```

2. In `lua/plugins/jupyter.lua`, change `enabled = false` → `enabled = true`

3. Reopen nvim, run `:Lazy sync`, then `:UpdateRemotePlugins`

4. Inside a `.py` or `.ipynb` file, run `:MoltenInit` to connect to a kernel

---

## Upgrading plugins

```
:Lazy update
```

Mason-installed tools:
```
:MasonUpdate
```
