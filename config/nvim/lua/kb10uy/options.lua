local option_pairs = {
  -- Encodings / Languages
  { "helplang", "ja,en" },
  { "encoding", "utf-8" },
  { "fileencodings", "utf-8" },

  -- Visual

  { "title", false },
  { "foldenable", false },
  { "ruler", true },
  { "number", true },
  { "completeopt", "menu" },
  { "cmdheight", 2 },
  { "laststatus", 2 },
  { "signcolumn", "yes" },

  -- Edit
  { "backspace", "" },
  { "softtabstop", 2 },
  { "shiftwidth", 2 },
  { "tabstop", 2 },
  { "expandtab", true },
  { "wildmenu", true },
  { "inccommand", "split" },
  { "mouse", "a" },
  { "hidden", true },
};

--- Checks whether the terminal has transparent/lucent background.
local function is_background_transparent()
  local trterm = vim.env.TRANSPARENTTERM or "";
  return trterm ~= "" or vim.g.nyaovim_version ~= nil;
end

--- Applies option values.
local function apply_options()
  vim.cmd("language ja_JP.UTF-8");

  -- Set options
  for _, option in ipairs(option_pairs) do
    vim.o[option[1]] = option[2];
  end
  -- TODO: How to set shada option correctly?
  vim.cmd("set shada=\"NONE\"");

  -- Set Python3 real path
  local python3_path = vim.env.PYTHON3_PATH or "";
  if python3_path ~= "" then
    vim.g.python_host_prog = python3_path;
  else
    vim.g.python_host_prog = vim.fn.trim(vim.fn.system("which python3"));
  end
end

--- Changes colorscheme.
local function apply_colorscheme()
  vim.o.background = "dark";
  vim.o.termguicolors = true;

  local term = vim.env.TERM;
  if term == "screen-256colors" then
    vim.o.t_8f = "<Esc>[38;2;%lu;%lu;%lum";
    vim.o.t_8b = "<Esc>[48;2;%lu;%lu;%lum";
  end

  -- Override some colors
  vim.cmd("colorscheme onehalfdark");
  if is_background_transparent() then
    vim.cmd("highlight! link SignColumn LineNr Normal");
    vim.cmd("highlight Normal ctermbg=NONE guibg=NONE");
    vim.cmd("highlight NormalFloat ctermbg=12 guibg=#2a4f54");
    vim.cmd("highlight clear CursorLine");
  end
end

return {
  apply_options = apply_options,
  apply_colorscheme = apply_colorscheme,
};
