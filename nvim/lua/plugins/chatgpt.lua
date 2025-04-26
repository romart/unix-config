return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  config = function()
    local gpt = require("chatgpt")
    local wk = require("which-key")
    -- Do not configure ChatGPT if key is not set
    if os.getenv("OPENAI_API_KEY") then
      gpt.setup({
        openai_params = {
          model = "gpt-4o-mini",
          -- frequency_penalty = 0,
          -- presence_penalty = 0,
          -- max_tokens = 4095,
          -- temperature = 0.2,
          -- top_p = 0.1,
          -- n = 1
        }
      })
      wk.add({
        { "<C-g>",  group = "ChatGPT" },
        { "<C-g>c", "<cmd>ChatGPT<CR>",                              desc = "ChatGPT" },
        { "<C-g>e", "<cmd>ChatGPTEditWithInstruction<CR>",           desc = "Edit with instruction",     mode = { "n", "v" } },
        { "<C-g>g", "<cmd>ChatGPTRun grammar_correction<CR>",        desc = "Grammar Correction",        mode = { "n", "v" } },
        { "<C-g>t", "<cmd>ChatGPTRun translate<CR>",                 desc = "Translate",                 mode = { "n", "v" } },
        { "<C-g>k", "<cmd>ChatGPTRun keywords<CR>",                  desc = "Keywords",                  mode = { "n", "v" } },
        { "<C-g>d", "<cmd>ChatGPTRun docstring<CR>",                 desc = "Docstring",                 mode = { "n", "v" } },
        { "<C-g>a", "<cmd>ChatGPTRun add_tests<CR>",                 desc = "Add Tests",                 mode = { "n", "v" } },
        { "<C-g>o", "<cmd>ChatGPTRun optimize_code<CR>",             desc = "Optimize Code",             mode = { "n", "v" } },
        { "<C-g>s", "<cmd>ChatGPTRun summarize<CR>",                 desc = "Summarize",                 mode = { "n", "v" } },
        { "<C-g>f", "<cmd>ChatGPTRun fix_bugs<CR>",                  desc = "Fix Bugs",                  mode = { "n", "v" } },
        { "<C-g>x", "<cmd>ChatGPTRun explain_code<CR>",              desc = "Explain Code",              mode = { "n", "v" } },
        { "<C-g>r", "<cmd>ChatGPTRun roxygen_edit<CR>",              desc = "Roxygen Edit",              mode = { "n", "v" } },
        { "<C-g>l", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis", mode = { "n", "v" } }
      })
    end
  end,

  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim", -- optional
    "nvim-telescope/telescope.nvim"
  }
}
