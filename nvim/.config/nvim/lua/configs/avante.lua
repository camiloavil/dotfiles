local options = {
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "vertex" | "cohere" | "copilot" | string
  provider = "claude",
  -- auto_suggestions_provider = "openai",
  ---@alias Tokenizer "tiktoken" | "hf"
  openai = {
    model = "gpt-4o-mini",
    -- model = "gpt-4o",
    max_tokens = 4096,
    -- endpoint = "https://api.openai.com/v1",
    -- timeout = 30000, -- Timeout in milliseconds
    -- temperature = 0,
  },
  ---@type AvanteSupportedProvider
  claude = {
    model = "claude-3-7-sonnet-20250219",
    max_tokens = 20480,
    -- endpoint = "https://api.anthropic.com",
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
  dual_boost = {
    enabled = false,
    first_provider = "openai",
    second_provider = "claude",
    prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
    timeout = 60000, -- Timeout in milliseconds
  },
  behaviour = {
    auto_suggestions = false, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
    minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
    enable_token_counting = true, -- Whether to enable token counting. Default to true.
    enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
    enable_claude_text_editor_tool_mode = false, -- Whether to enable Claude Text Editor Tool Mode.
  },
  web_search_engine = {
    provider = "tavily",
    proxy = nil,
    providers = {
      tavily = {
        api_key_name = "TAVILY_API_KEY",
        extra_request_body = {
          include_answer = "basic",
        },
        ---@type WebSearchEngineProviderResponseBodyFormatter
        format_response_body = function(body) return body.answer, nil end,
      },
    },
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
      insert = "<C-s>",
    },
    cancel = {
      normal = { "<C-c>", "<Esc>", "q" },
      insert = { "<C-c>" },
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
      retry_user_request = "r",
      edit_user_request = "e",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
      remove_file = "d",
      add_file = "@",
      close = { "<Esc>", "q" },
      ---@alias AvanteCloseFromInput { normal: string | nil, insert: string | nil }
      ---@type AvanteCloseFromInput | nil
      close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
    },
    files = {
      add_current = "<leader>ac", -- Add current buffer to selected files
      add_all_buffers = "<leader>aB", -- Add all buffer files to selected files
    },
    select_model = "<leader>a?", -- Select model command
    select_history = "<leader>ah", -- Select history command
  },
}
return options
