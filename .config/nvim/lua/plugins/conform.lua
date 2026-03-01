return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "ruff_format" },
    },
    formatters = {
      ruff_format = {
        args = {
          "format",
          "--line-length",
          "88",
          "--stdin-filename",
          "$FILENAME",
          "-",
        },
      },
    },
  },
}
