return {
  "saghen/blink.cmp",
  dependencies = { "L3MON4D3/LuaSnip" },
  opts = {
    snippets = { preset = "luasnip" },
    -- "snippets" is already in LazyVim's default sources, but be explicit if unsure:
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
  },
}
