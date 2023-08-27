vim.keymap.set("n", "<leader>aa", function()
    vim.cmd.w()
    vim.cmd.ArduinoUpload()
end)
