-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.keymap.set("n", "<leader>o", function()
  vim.b.autoformat = false
  vim.cmd("w")
  vim.b.autoformat = true
end)
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
-- vim.keymap.set("i", "x", "w")
