vim.lsp.config.pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyrightconfig.json", "pyproject.toml", "setup.py" },
}
vim.lsp.enable("pyright")

vim.lsp.config["rust-analyzer"] = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml" },
}
vim.lsp.enable("rust-analyzer")

vim.lsp.config.clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = { ".clangd", "compile_commands.json" },
}
vim.lsp.enable("clangd")
