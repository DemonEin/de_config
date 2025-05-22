local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    root_dir = function()
        return vim.fs.dirname(vim.fs.find({'pyrightconfig.json', 'pyproject.toml', 'setup.py'}, { upward = true })[1])
    end,
}
require('lspconfig')['rust_analyzer'].setup{
    on_attach = function(client, bufnr)

        vim.api.nvim_create_autocmd({'TextChanged', 'InsertLeave'}, {
            callback = function()
                if #vim.lsp.get_active_clients({ name = 'rust_analyzer' }) ~= 0 then
                    vim.cmd('write')
                end
            end,
            buffer = bufnr,
            nested = true,
        })

        on_attach(client, bufnr)

    end,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}

require('lspconfig')['clangd'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

