local nvim_autopairs = {}

nvim_autopairs.setup = function(plugins)

  -- nvim_autopairs.nvim
  table.insert(plugins, {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  })

  return plugins
end

return nvim_autopairs
