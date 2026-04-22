-- Python LSP (pyright) + nvim-cmp autocomplete with auto-import.
-- Virtualenv detection: $VIRTUAL_ENV → ./.venv → ./venv → system python3.
-- Requires nvim 0.11+ (uses vim.lsp.config / vim.lsp.enable).
-- Plugins: neovim/nvim-lspconfig, hrsh7th/nvim-cmp, hrsh7th/cmp-nvim-lsp,
--          hrsh7th/cmp-buffer, hrsh7th/cmp-path, L3MON4D3/LuaSnip,
--          saadparwaiz1/cmp_luasnip.
-- External: pyright (`brew install pyright` or `npm install -g pyright`).

if vim.fn.executable("pyright-langserver") == 0 then
  vim.schedule(function()
    vim.notify("pyright not on PATH — run `brew install pyright`", vim.log.levels.WARN)
  end)
  return
end

local ok_cmp, cmp = pcall(require, "cmp")
local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local ok_luasnip, luasnip = pcall(require, "luasnip")

-- Resolve the Python interpreter for the current cwd, preferring a venv.
local function detect_python()
  local venv = os.getenv("VIRTUAL_ENV")
  if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
    return venv .. "/bin/python", venv
  end
  local cwd = vim.fn.getcwd()
  for _, dir in ipairs({ ".venv", "venv" }) do
    local path = cwd .. "/" .. dir
    if vim.fn.isdirectory(path) == 1 and vim.fn.executable(path .. "/bin/python") == 1 then
      return path .. "/bin/python", path
    end
  end
  return vim.fn.exepath("python3"), nil
end

local python_path, venv_path = detect_python()

-- nvim-cmp: autocomplete UI + sources.
if ok_cmp then
  cmp.setup({
    snippet = ok_luasnip and {
      expand = function(args) luasnip.lsp_expand(args.body) end,
    } or nil,
    mapping = cmp.mapping.preset.insert({
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping.select_next_item(),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer" },
      { name = "path" },
    }),
  })
end

-- LSP capabilities from cmp (advertises completion support to the server).
local capabilities = ok_cmp_lsp
  and cmp_nvim_lsp.default_capabilities()
  or vim.lsp.protocol.make_client_capabilities()

-- pyright via the nvim 0.11 vim.lsp.config API. autoImportCompletions gives
-- the "auto-import" behavior on accepting a completion for an unimported symbol.
vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  capabilities = capabilities,
  settings = {
    python = {
      pythonPath = python_path,
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "basic",
      },
    },
  },
})
vim.lsp.enable("pyright")

-- Buffer-local LSP keymaps, attached only when a server is active.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("pm-lsp-attach", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "LSP: go to definition")
    map("gr", vim.lsp.buf.references, "LSP: references")
    map("K",  vim.lsp.buf.hover, "LSP: hover docs")
    map("<leader>rn", vim.lsp.buf.rename, "LSP: rename")
    map("<leader>ca", vim.lsp.buf.code_action, "LSP: code action (auto-import, fixes)")
    map("<leader>f",  function() vim.lsp.buf.format({ async = true }) end, "LSP: format buffer")
  end,
})

if venv_path then
  vim.schedule(function()
    vim.notify("Python LSP: using venv " .. venv_path, vim.log.levels.INFO)
  end)
end
