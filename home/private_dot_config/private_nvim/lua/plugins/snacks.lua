return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
          },
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
      image = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Set custom highlight groups for explorer
      vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Text" })
      vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Text" })
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "Special" })
    end,
  },
}
