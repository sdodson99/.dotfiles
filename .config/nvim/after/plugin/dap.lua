require('dap').adapters.chrome = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/.config/nvim/debuggers/vscode-chrome-debug/out/src/chromeDebug.js" }
}

require("dapui").setup({
    expand_lines = false,
    layouts = {
        {
            elements = {
                {
                    id = "scopes",
                    size = 1
                }
            },
            position = "right",
            size = 40
        }
    }
})
