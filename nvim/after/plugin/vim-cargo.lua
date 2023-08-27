vim.keymap.set('n', '<leader>rr', function()
    vim.cmd.w()
    vim.cmd.CargoRun()
end)

vim.keymap.set('n', '<leader>rt', function()
    vim.cmd.w()
    vim.cmd.CargoTest()
end)

vim.keymap.set('n', '<leader>rb', function()
    vim.cmd.w()
    vim.cmd.CargoBuild()
end)
