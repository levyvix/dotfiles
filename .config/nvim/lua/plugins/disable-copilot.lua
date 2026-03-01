return {
  { "zbirenbaum/copilot.lua", enabled = false },
  { "fang2hou/blink-copilot", enabled = false },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        copilot = { enabled = false },
      },
    },
  },
}
