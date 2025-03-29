--- @type LazySpec
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = "*", -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.

  ---@type avante.Config
  opts = {
    -- add any opts here
    -- for example
    provider = "openai",
    openai = {
      model = "gpt-4o"
    },
    claude = {
      model = "claude-3-5-sonnet-latest",
      max_tokens = 8192,
    },
    rag_service = {
      enabled = true,
      host_mount = os.getenv("HOME"),
      provider = "openai",
      llm_model = "gpt-4o",
      embed_model = "text-embedding-ada-002",
      endpoint = "https://api.openai.com/v1/",
    },
    file_selector = {
      provider = "snacks",
    },
    behaviour = {
      auto_suggestions = false,


      -- auto_apply_diff_after_generation = true,
      -- enable_claude_text_editor_tool_mode = true,
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
  },
}
