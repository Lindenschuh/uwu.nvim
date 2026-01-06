if vim.fn.has 'nvim-0.11.0' ~= 1 then
  vim.api.nvim_echo({ { 'uwu.nvim requires at least nvim-0.11.0.'} }, true, { err = true })
end
