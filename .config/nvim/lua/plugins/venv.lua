return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
  },
  lazy = false, -- Load immediately instead of on Python file open
  keys = {
    { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "VenvSelect"}, -- Open picker on keymap
  },
  opts = { -- this can be an empty lua table - just showing below for clarity.
      search = {}, -- if you add your own searches, they go here.
      options = {} -- if you add plugin options, they go here.
  },
}
