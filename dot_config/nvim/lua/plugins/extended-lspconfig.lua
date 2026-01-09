return {
  require('lspconfig').ruff.setup{
    settings = {
        -- Any extra CLI arguments for `ruff` go here.
        args = {
            "--line-length=100",
        },
      },
  },
}
