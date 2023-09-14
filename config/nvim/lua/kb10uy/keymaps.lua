local map_nore = { noremap = true };
local map_norenow = { noremap = true, nowait = true };
local map_noreexpr = { noremap = true, expr = true };

local keymap_pairs = {
  { "", "a", "h", map_norenow },
  { "", "s", "j", map_norenow },
  { "", "w", "k", map_norenow },
  { "", "d", "l", map_norenow },
  { "", "W", "<C-u>", map_norenow },
  { "", "S", "<C-d>", map_norenow },
  { "", "D", "I", map_norenow },
  { "", ",", "b", map_norenow },
  { "", ".", "w", map_norenow },
  { "", "<lt>", "<Home>", map_norenow },
  { "", ">", "<End>", map_norenow },
  { "", "??", "<lt><lt>", map_norenow },
  { "", "D", "I", map_norenow },
  { "o", "a", false },
  { "o", "s", false },
  { "o", "w", false },
  { "o", "d", false },

  { "", "x", "\"_x" },
  { "", "e", "c" },
  { "", "q", "\"_d" },
  { "", "r", "y" },
  { "n", "ee", "cc<Esc>" },
  { "n", "qq", "\"_dd" },
  { "n", "rr", "yy" },
  { "n", "F", "p" },
  { "n", "f", "P" },
  { "v", "e", "d" },
  { "n", "<C-w>", "<C-a>" },
  { "n", "<C-s>", "<C-x>" },

  { "", "<M-I>", "gg=G2<C-O>" },
  { "t", "<M-Esc>", "<C-\\><C-n>" },
  { "", "<C-q>", "<Esc>" },
  { "i", "<C-q>", "<Esc>" },
  { "t", "<C-q>", "<C-\\><C-n>" },
  { "", "m", "q" },

  { "", "z", "u" },
  { "", "Z", "<C-r>" },

  { "", "<Home>", "" },
  { "", "<End>", "" },
  { "", "<Up>", "" },
  { "", "<Down>", "" },
  { "", "<Left>", "" },
  { "", "<Right>", "" },
  { "i", "<Up>", "" },
  { "i", "<Down>", "" },
  { "i", "<Left>", "" },
  { "i", "<Right>", "" },
  { "c", "<C-w>", "<Up>" },
  { "c", "<C-s>", "<Down>" },
  { "c", "<C-a>", "<Left>" },
  { "c", "<C-d>", "<Right>" },
  { "t", "<C-w>", "<Up>" },
  { "t", "<C-s>", "<Down>" },
  { "t", "<C-a>", "<Left>" },
  { "t", "<C-d>", "<Right>" },

  { "n", "<C-t>", ":tabe " },
  { "n", "<C-d>", "gt" },
  { "n", "<C-a>", "gT" },

  { "n", "<C-f>", "<cmd>lua require(\"fzf-lua\").files()<CR>" },
  { "n", "<C-g>", "<cmd>lua require(\"fzf-lua\").git_files()<CR>" },
  { "n", "<C-r>", "<cmd>lua require(\"fzf-lua\").live_grep()<CR>" },

  { "i", "<Tab>", "pumvisible() ? \"<C-n>\" : \"<Tab>\"", map_noreexpr },
  { "i", "<S-Tab>", "pumvisible() ? \"<C-p>\" : \"<S-Tab>\"", map_noreexpr },
};

--- Applies keymaps.
local function apply_keymaps()
  for _, keymap in ipairs(keymap_pairs) do
    if keymap[3] ~= false then
      local flags = keymap[4] or map_nore;
      vim.api.nvim_set_keymap(keymap[1], keymap[2], keymap[3], flags);
    else
      vim.api.nvim_del_keymap(keymap[1], keymap[2]);
    end
  end
end

--- Registers user commands.
local function register_commands()
  vim.api.nvim_create_user_command("Q", "<line1>,<line2>d", { range = true });
  vim.api.nvim_create_user_command("E", "<line1>,<line2>c", { range = true });
  vim.api.nvim_create_user_command("R", "<line1>,<line2>y", { range = true });
end

return {
  apply_keymaps = apply_keymaps,
  register_commands = register_commands,
};
