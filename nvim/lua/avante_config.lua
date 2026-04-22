require("avante").setup({
  provider = "openai",
  mode = "agentic",

  behaviour = {
    auto_suggestions = false,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
  },

  providers = {
    openai = {
      endpoint = "https://api.openai.com/v1",
      model = "gpt-4o",
      timeout = 30000,
      extra_request_body = {
        temperature = 0.7,
        max_tokens = 8192,
      },
    },
  },

  instructions_file = "avante.md",
})
