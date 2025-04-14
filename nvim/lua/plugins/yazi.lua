return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
  config = function()
    require("yazi").setup {}
    local wk = require("which-key")
    -- TODO: use direct calls to yazi
    wk.add(
      {
        { "<leader>y",  group = "Yazi" },
        { "<leader>yn", "<cmd>Yazi<cr>",        desc = "Open yazi at the current file" },
        { "<leader>yt", "<cmd>Yazi toggle<CR>", desc = "Resume the last yazi session" },
        { "<leader>yw", "<cmd>Yazi cwd<cr>",    desc = "Open the file manager in nvim's working directory" },
      }
    )
  end
}
