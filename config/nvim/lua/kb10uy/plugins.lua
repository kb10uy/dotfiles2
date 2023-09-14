--- Ensures that lazy.nvim is installed.
local function ensure_lazy_nvim()
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim";
  if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazy_path,
    });
  end
  vim.opt.rtp:prepend(lazy_path);
end

--- Returns plugins table.
local function lazy_nvim_plugins()
  return {
    -- Editor extensions
    "editorconfig/editorconfig-vim",
    "kana/vim-operator-user",
    { "mattn/emmet-vim", ft = { "html", "php" } },
    {
      "rhysd/vim-operator-surround",
      dependencies = {
        "vim-operator-user",
      },
      event = "InsertEnter",
    },
    {
      "ibhagwan/fzf-lua",
      lazy = true,
      config = function()
        require("fzf-lua").setup({});
      end,
    },

    -- Filetypes
    { "dag/vim-fish", ft = "fish" },
    { "cespare/vim-toml", ft = "toml" },
    { "othree/yajs.vim", ft = "javascript" },
    { "leafgarland/typescript-vim", ft = "typescript" },
    { "rust-lang/rust.vim", ft = "rust" },
    { "StanAngeloff/php.vim", ft = "php" },
    { "chr4/nginx.vim", ft = "nginx" },
    {
      "lifepillar/pgsql.vim",
      ft = "sql",
      config = function()
        vim.g.sql_type_default = "pgsql";
      end,
    },

    -- LSP
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
      },
      ft = {
        "rust", "go",
        "c", "cpp",
        "javascript", "typescript",
        "php", "kotlin",
      },
      config = require("kb10uy.plugins").initialize_lsp,
    },

    -- Misc.
    "vim-jp/vimdoc-ja",
    "lifepillar/vim-solarized8",
  };
end

--- Returns lazy.nvim configuration.
local function lazy_nvim_config()
  return nil;
end

--- Initializes LSP server settings.
local function initialize_lsp()
  local lspconfig = require("lspconfig");
  local cmp = require("cmp");
  local types = require("cmp.types");
  local cmp_lsp = require("cmp_nvim_lsp");

  cmp.setup({
    snippet = {
      expand = function (args)
        vim.fn["vsnip#anonymous"](args.body);
      end,
    },
    mapping = {
      ["<C-w>"] = { i = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }) },
      ["<C-s>"] = { i = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }) },
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources(
      {
        { name = "nvim_lsp" },
        { name = "vsnip" },
      },
      {
        { name = "buffer" },
      }
    ),
  });

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer"},
    },
  });
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      {
        { name = "path" },
      },
      {
        { name = "cmdline" },
      }
    )
  });

  -- Register LSP servers
  local capabilities = cmp_lsp.default_capabilities();
  lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    cmd = { "rustup", "run", "stable", "rust-analyzer" },
  });
  lspconfig.clangd.setup({ capabilities = capabilities });

  -- Set completion options
  vim.opt.completeopt = { "noinsert", "menuone", "noselect" };
  vim.opt.shortmess:append({ c = true });
end

return {
  ensure_lazy_nvim = ensure_lazy_nvim,
  lazy_nvim_plugins = lazy_nvim_plugins,
  lazy_nvim_config = lazy_nvim_config,
  initialize_lsp = initialize_lsp,
};
