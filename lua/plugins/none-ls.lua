return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- Formatters & linters for mason to install
    require('mason-null-ls').setup {
      ensure_installed = {
        'stylua', -- lua formatter
        'shfmt', -- shell formatter
        'yamllint', -- yaml linter
        'checkmake', -- linter for Makefiles
        'prettier', -- universal formatter for json, yaml, markdown
      },
      automatic_installation = true,
    }

    local sources = {
      -- Formatters
      formatting.stylua,
      formatting.shfmt.with { args = { '-i', '2', '-ci' } }, -- 2 spaces indentation with switch cases
      formatting.prettier.with {
        filetypes = { 'json', 'yaml', 'markdown', 'toml' },
      },
      -- Linters
      diagnostics.yamllint,
      diagnostics.checkmake,
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client:supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }
  end,
}
