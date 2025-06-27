return {
  'uga-rosa/translate.nvim',
  cmd = { 'Translate' },
  config = function()
    require('translate').setup {
      default = {
        command = 'translate_shell',
      },
    }
  end,
  keys = {
    {
      '<leader>mw',
      'viw:Translate zh-TW<CR>',
      mode = 'n',
      desc = 'Translate word under cursor to Traditional Chinese',
    },
    {
      '<leader>ms',
      function()
        -- 取得當前行和游標位置
        local line = vim.api.nvim_get_current_line()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        -- 從游標位置開始的文字
        local text_from_cursor = line:sub(col + 1)
        -- 移除註解符號
        text_from_cursor = text_from_cursor:gsub('^%s*%-%-+%s*', '') -- --
        text_from_cursor = text_from_cursor:gsub('^%s*//+%s*', '') -- //
        text_from_cursor = text_from_cursor:gsub('^%s*#+%s*', '') -- #
        -- 找到句號或行尾
        local period_pos = text_from_cursor:find '%.'
        if period_pos then
          text_from_cursor = text_from_cursor:sub(1, period_pos - 1)
        end
        -- 清理空白
        text_from_cursor = vim.trim(text_from_cursor)
        if text_from_cursor ~= '' then
          -- 計算選取範圍
          local start_col = col + 1
          local end_col = start_col + #text_from_cursor - 1
          -- 設定選取範圍
          vim.api.nvim_win_set_cursor(0, { row, start_col - 1 })
          vim.cmd 'normal! v'
          vim.api.nvim_win_set_cursor(0, { row, end_col - 1 })
          -- 執行翻譯
          vim.cmd 'Translate zh-TW'
        else
          print '找不到可翻譯的文字'
        end
      end,
      mode = 'n',
      desc = 'Translate comment from cursor to period',
    },
    -- 新增視覺模式翻譯
    {
      '<leader>mv',
      '<cmd>Translate zh-TW<cr>',
      mode = 'v',
      desc = 'Translate selected text to Traditional Chinese',
    },
    {
      '<leader>mV',
      '<cmd>Translate zh-TW -output=replace<cr>',
      mode = 'v',
      desc = 'Translate selected text and replace',
    },
  },
}
