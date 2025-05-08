---@type vim.lsp.Config
return {
    cmd = { "pyright-langserver", "--stdio" },
    root_markers = {},
    filetypes = { "python", "py" },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
            },
        },
    },
}
