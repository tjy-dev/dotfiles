local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {}

-- Define plugins
local plugins = {
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = "yarn install --frozen-lockfile",
    config = function()
      -- Minimal coc.nvim configuration
      vim.opt.backup = false
      vim.opt.writebackup = false
      vim.opt.updatetime = 300
      vim.opt.signcolumn = "yes"

      local keyset = vim.keymap.set
                                                                                                                             
      function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end
                                                                                                                             
      local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}

      keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
      keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
      keyset("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
      keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})
      keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
      keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})
      keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
      keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
      keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
      keyset("n", "gr", "<Plug>(coc-references)", {silent = true})
    end,

    event = "InsertEnter",
  },
}

-- Ex.
-- plugins = require("hoge").setup(plugins)

-- git
require('plugins_git').setup(plugins)

-- which_key.nvim
require("plugins_which_key").setup(plugins)

-- nvim-autopairs.nvim
require("plugins_nvim-autopairs").setup(plugins)

-- catpuccin
require("plugins_colorscheme").setup(plugins)

-- setup lazy
require("lazy").setup(plugins, opts)

-- keymaps after plugin setup (collision)
require("keymaps")
