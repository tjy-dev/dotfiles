-- basic settings
local opt = vim.opt
-- 「※」等の記号を打つと、半角文字と重なる問題がある。「※」などを全角文字の幅で表示するために設定する
-- opt.ambiwidth = 'double'

-- 新しい行を改行で追加した時に、ひとつ上の行のインデントを引き継がせます。
opt.autoindent = true
opt.smartindent = true
-- smartindent と cindent を両方 true にしたときは、cindent のみ true になるようです。
-- opt.cindent = true
-- カーソルが存在する行にハイライトを当ててくれます。
opt.cursorline = true

-- カーソルが存在する列にハイライトを当てたい場合、下記をtrueにする。
-- opt.cursorculumn = true

-- TABキーを押した時に、2文字分の幅を持ったTABが表示されます。
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
-- tabstop で設定した数の分の半角スペースが入力されます。
opt.expandtab = true
-- カーソル行からの相対的な行番号を表示する
opt.number = true
opt.termguicolors = true

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
-- vim.lsp.diagnostic.on_publish_diagnostics, {
-- -- delay update diagnostics
--     update_in_insert = true,
--   }
-- )
opt.signcolumn = 'yes'

-- lazy nvim and plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system(
    { "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
      lazypath })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({ {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim"                                                       -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = true
}, {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall" },
  event = { "WinNew", "WinLeave", "BufRead" },
  config = function()
    require("mason").setup()
  end
}, {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspLog" },
  event = { "BufRead" },
  dependencies = { {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup({ ensure_installed = { "lua_ls" }, })
      require("mason-lspconfig").setup_handlers { function(server_name)
        require("lspconfig")[server_name].setup {
          on_attach = on_attach,
          capabilities = capabilities
        }
      end }
    end
  }, {
    "lukas-reineke/lsp-format.nvim",
    config = function()
      require("lsp-format").setup {}

      local on_attach = function(client)
        require("lsp-format").on_attach(client)
        -- ... custom code ...
      end
      require("lspconfig").lua_ls.setup { on_attach = on_attach }
    end
  } }

}, {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.5',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    vim.api.nvim_set_keymap('n', '<Leader>f',
      [[<Cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({}))<CR>]], {
        noremap = true,
        silent = true
      })
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fF', builtin.current_buffer_fuzzy_find, {})
    vim.keymap.set('n', '<leader>fr', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fg', builtin.grep_string, {})
    vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
    vim.keymap.set("n", "<leader>fp", builtin.registers, {})
  end
}, { 'nvim-treesitter/nvim-treesitter' }, {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = true
}, {
  'hrsh7th/nvim-cmp',
  config = function()
    local cmp = require 'cmp'
    cmp.setup({
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
          -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<CR>'] = cmp.mapping.confirm {
          select = false
        },
        ['<C-e>'] = cmp.mapping.abort()
      }),
      sources = cmp.config.sources({ {
        name = 'nvim_lsp'
      }, --  {
        --     name = 'vsnip'
        -- }
        -- For vsnip users.
        {
          name = 'luasnip'
        } -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
      }, { {
        name = 'buffer'
      } })
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({ {
        name = 'git'
      } -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
      }, { {
        name = 'buffer'
      } })
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { {
        name = 'buffer'
      } }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ {
        name = 'path'
      } }, { {
        name = 'cmdline'
      } })
    })

    -- Set up lspconfig.
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
      capabilities = capabilities
    }
  end,
  lazy = true,
  event = "InsertEnter",
  dependencies = { -- apearance
    {
      'onsails/lspkind.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    }, -- source
    { 'hrsh7th/cmp-nvim-lsp' }, { 'hrsh7th/cmp-nvim-lsp-signature-help' }, { 'hrsh7th/cmp-buffer' }, { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' }, { 'hrsh7th/cmp-nvim-lsp-document-symbol' }, { "f3fora/cmp-spell" }, { "ray-x/cmp-treesitter" },
    -- snippet
    { 'L3MON4D3/LuaSnip' }, { 'saadparwaiz1/cmp_luasnip' } }
}, })

-- require("mason").setup()
-- require("mason-lspconfig").setup()
