return {
  'uga-rosa/translate.nvim',
  config = function()
    require('translate').setup {
      default = {
        command = 'translate_shell',
      },
    }
  end,
  keys = {
    -- English to Traditional Chinese (Display)
    {
      '<leader>me',
      '<cmd>Translate zh-TW<cr>',
      mode = { 'n', 'v' },
      desc = 'English to Traditional Chinese',
    },
    -- Traditional Chinese to English (Display)
    {
      '<leader>mc',
      '<cmd>Translate en<cr>',
      mode = { 'n', 'v' },
      desc = 'Traditional Chinese to English',
    },
    -- English to Traditional Chinese (Replace)
    {
      '<leader>mE',
      '<cmd>Translate zh-TW -output=replace<cr>',
      mode = { 'n', 'v' },
      desc = 'English to Traditional Chinese (Replace)',
    },
    -- Traditional Chinese to English (Replace)
    {
      '<leader>mC',
      '<cmd>Translate en -output=replace<cr>',
      mode = { 'n', 'v' },
      desc = 'Traditional Chinese to English (Replace)',
    },
  },
}
