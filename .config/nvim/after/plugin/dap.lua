require'dap'.adapters.chrome = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/.config/nvim/debuggers/vscode-chrome-debug/out/src/chromeDebug.js" }
}

