-- ~/.config/nvim/lua/plugins/luasnip.lua
-- This is the ONLY place that configures LuaSnip. Do not load snippets anywhere
-- else (no loader lines in lazy.lua or init.lua), or you will get conflicts.

return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" }, -- restores the stock snippet set
  config = function(_, opts)
    local ls = require("luasnip")

    opts = opts or {}
    opts.update_events = "TextChanged,TextChangedI" -- live-update derived tags as you type
    opts.region_check_events = "CursorMoved,CursorMovedI" -- end the session when the cursor leaves it
    opts.delete_check_events = "TextChanged,InsertLeave" -- tidy up if you delete the snippet text
    ls.setup(opts)

    -- snippet sources
    require("luasnip.loaders.from_vscode").lazy_load() -- friendly-snippets (VS Code style)
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/luasnippets" }, -- your custom snippets live here
    })

    -- keymaps (insert + select mode)
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      ls.jump(1) -- jump to next slot
    end, { silent = true, desc = "LuaSnip: next slot" })

    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      ls.jump(-1) -- jump to previous slot
    end, { silent = true, desc = "LuaSnip: previous slot" })

    vim.keymap.set({ "i", "s" }, "<C-l>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end -- cycle a choice slot (e.g. gf constraints)
    end, { silent = true, desc = "LuaSnip: cycle choice" })

    vim.keymap.set({ "i", "s", "n" }, "<C-e>", function()
      if ls.in_snippet() then
        ls.unlink_current()
      end -- force-exit the snippet right now
    end, { silent = true, desc = "LuaSnip: exit snippet" })
  end,
}
