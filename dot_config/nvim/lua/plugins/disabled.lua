return {
  { 'mini-nvim/mini.animate', enabled = false },

  -- Disable pyright auto-install
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          enabled = true,
        },
      },
    },
  },
}
