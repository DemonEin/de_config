vim.lsp.config.pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyrightconfig.json", "pyproject.toml", "setup.py" },
}
vim.lsp.enable("pyright")

-- special configuration is for rustc
-- taken from https://rustc-dev-guide.rust-lang.org/building/suggested.html "Neovim" with
-- modifications
local rustc_path = vim.fs.abspath("~/rust")

vim.lsp.config["rust-analyzer"] = {
    -- for debugging, uncomment
    --[[
    cmd_env = {
        RA_LOG = "rust_analyzer=info",
    },
    --]]
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = function(buffer_number, on_dir)
        local git_root = vim.fs.root(buffer_number, ".git")
        if git_root == rustc_path then
            on_dir(git_root)
            return
        end

        local default_root = vim.fs.root(buffer_number, "Cargo.toml")
        if default_root then
            on_dir(default_root)
            return
        end
    end,
    before_init = function(initialize_params, client_config)
        local root_directory = initialize_params.rootUri -- of the form "file://<root directory>"
        if root_directory == "file://" .. rustc_path then
            local config = vim.fs.joinpath(root_directory:sub(8), "src/etc/rust_analyzer_zed.json")
            if vim.uv.fs_stat(config) then
                -- load rust-lang/rust settings
                local config_file = io.open(config)
                local settings = vim.json.decode(config_file:read("*a")).lsp["rust-analyzer"].initialization_options
                initialize_params.initializationOptions = settings
            else
                error("could not find rust-analyzer config file for rustc")
            end
        end
    end,
}
vim.lsp.enable("rust-analyzer")

vim.lsp.config.clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = { ".clangd", "compile_commands.json" },
}
vim.lsp.enable("clangd")
