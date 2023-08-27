api = vim.api

api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    --desc = "automatically resize windows when host window size changes"
    command = "wincmd =",
})
