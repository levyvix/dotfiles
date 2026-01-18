return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        ruff = {
          settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {
              "--line-length=88",
            },
          },
        },
      },
    },
  },
}
