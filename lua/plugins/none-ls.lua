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
        'prettier', -- ts/js/jsx/tsx formatter
        'eslint_d', -- ts/js/jsx/tsx linter (fast daemon version)
        'stylua', -- lua formatter for Neovim config
      },
      automatic_installation = true,
    }

    local sources = {
      -- Formatters
      formatting.prettier.with {
        filetypes = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'css',
          'scss',
          'html',
          'json',
          'yaml',
          'markdown',
        },
      },
      formatting.stylua, -- for Neovim Lua config

      -- Linters (using eslint_d from none-ls-extras)
      require('none-ls.diagnostics.eslint_d').with {
        condition = function(utils)
          return utils.root_has_file { '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc.json', 'eslint.config.js' }
        end,
      },

      -- Code actions (using eslint_d from none-ls-extras)
      require('none-ls.code_actions.eslint_d').with {
        condition = function(utils)
          return utils.root_has_file { '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc.json', 'eslint.config.js' }
        end,
      },
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
