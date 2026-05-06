
require("yafg"):setup({
  editor = "nvim",                    -- Editor command (default: "hx")
  args = { "--noplugin" },            -- Additional editor arguments (default: {})
  file_arg_format = "+{row} {file}",  -- File argument format (default: "{file}:{row}:{col}")
})
