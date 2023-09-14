local plugins = require("kb10uy.plugins");
plugins.ensure_lazy_nvim();
require("lazy").setup(
  plugins.lazy_nvim_plugins(),
  plugins.lazy_nvim_config()
);

vim.api.nvim_create_autocmd(
  'VimEnter',
  {
    callback = function()
      local options = require("kb10uy.options");
      local keymaps = require("kb10uy.keymaps");
      options.apply_colorscheme();
      options.apply_options();
      keymaps.apply_keymaps();
      keymaps.register_commands();
    end,
  }
);
