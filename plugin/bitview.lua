local bitview = require("bitview")

vim.api.nvim_create_user_command("BitView", bitview.open, {})
vim.keymap.set("n", "gh", "<cmd>BitView<cr>")
