return {
  -- Prisma syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "prisma" } },
  },

  -- Prisma language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { prismals = {} },
    },
  },

  -- Make sure Mason installs the prisma language server binary
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "prisma-language-server" } },
  },
}
