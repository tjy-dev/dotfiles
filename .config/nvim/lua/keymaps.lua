local keyset = vim.keymap.set

-- s を 画面移動系のprefixに
keyset('n', 's', '<NOP>')

keyset('n', 'sq', ':quit<CR>')

-- 分割
keyset('n', 'ss', ':sp<CR>')
keyset('n', 'sv', ':vs<CR>')

-- 分割移動
keyset('n', 'sj', '<C-w>j')
keyset('n', 'sk', '<C-w>k')
keyset('n', 'sh', '<C-w>h')
keyset('n', 'sl', '<C-w>l')
keyset('n', 'sJ', '<C-w>J')
keyset('n', 'sK', '<C-w>K')
keyset('n', 'sH', '<C-w>H')
keyset('n', 'sL', '<C-w>L')

-- タブページ
keyset('n', 'st', ':tabnew<CR>')
keyset('n', 'sn', 'gt')
keyset('n', 'sp', 'gT')
keyset('n', 'sN', ':tabmove +1<CR>')
keyset('n', 'sP', ':tabmove -1<CR>')
