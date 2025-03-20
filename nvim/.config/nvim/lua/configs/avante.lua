local options = {
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "vertex" | "cohere" | "copilot" | string
  provider = "openai",
  auto_suggestions_provider = "openai",
  ---@alias Tokenizer "tiktoken" | "hf"
  openai = {
    -- model = "gpt-4o-mini",
    model = "gpt-4o",
    max_tokens = 4096,
    -- endpoint = "https://api.openai.com/v1",
    -- timeout = 30000, -- Timeout in milliseconds
    -- temperature = 0,
  },
  copilot = {
    endpoint = "https://api.githubcopilot.com",
    model = "gpt-4o-2024-08-06",
    proxy = nil, -- [protocol://]host[:port] Use this proxy
    allow_insecure = false, -- Allow insecure server connections
    timeout = 30000, -- Timeout in milliseconds
    temperature = 0,
    max_tokens = 4096,
  },
  mappings = {
    ---@class AvanteConflictMappings
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-a>",
    },
    -- NOTE: The following will be safely set by avante.nvim
    ask = "<leader>aa",
    edit = "<leader>ae",
    refresh = "<leader>ar",
    focus = "<leader>af",
    toggle = {
      default = "<leader>at",
      debug = "<leader>ad",
      hint = "<leader>ah",
      suggestion = "<leader>as",
      repomap = "<leader>aR",
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
      remove_file = "d",
      add_file = "@",
    },
    files = {
      add_current = "<leader>ac", -- Add current buffer to selected files
    },
  },
}
return options
