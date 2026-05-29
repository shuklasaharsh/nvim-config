return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "ToggleTermToggleAll", "TermExec" },
  keys = {
    { "<C-\\>", "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle terminal" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal (float)" },
    { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal (horizontal)" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Terminal (vertical)" },
    {
      "<leader>gg",
      function()
        require("toggleterm.terminal").Terminal
          :new({
            cmd = "lazygit",
            direction = "float",
            hidden = true,
            on_open = function(term)
              -- let lazygit handle <esc> itself instead of dropping to normal mode
              vim.keymap.set("t", "<esc>", "<esc>", { buffer = term.bufnr })
            end,
          })
          :toggle()
      end,
      desc = "Lazygit (float)",
    },
  },
  opts = {
    open_mapping = [[<c-\>]],
    direction = "horizontal", -- docked at the bottom, JetBrains style
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    persist_size = true,
    persist_mode = true,
    shade_terminals = true,
    start_in_insert = true,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Make navigating out of the terminal feel native.
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*toggleterm#*",
      callback = function()
        local o = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], o)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], o)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], o)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], o)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], o)
      end,
    })
  end,
}
