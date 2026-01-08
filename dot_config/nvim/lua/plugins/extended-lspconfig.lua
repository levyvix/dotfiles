return {
  require('lspconfig').ruff.setup{
    -- Ruff agora usa o arquivo de configuração em ~/.config/ruff/ruff.toml
    -- ou ruff.toml/pyproject.toml no diretório do projeto
    settings = {},
  },
}
