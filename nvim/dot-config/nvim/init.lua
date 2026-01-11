-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.keymap.set("n", "<leader>o", function()
  vim.api.nvim_put({ "()=>{}" }, "c", true, true)
end)
local s = vim.keymap.set
local p = vim.api.nvim_put
s("n", "<leader>jj", function()
  p({ "()=>{}" }, "c", false, true)
  vim.api.nvim_input("hi")
end)
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
-- vim.keymap.set("i", "x", "w")
