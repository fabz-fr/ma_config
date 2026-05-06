
-- -------------------------------------------------------------------------------------------------
-- Highlight custom functions
-- -------------------------------------------------------------------------------------------------
local HighlightManager = {}

HighlightManager.fgcolor = "FFFFFF"
HighlightManager.highlight_ids = {}
HighlightManager.nbhighlight = 0

-- Constants for color generation
local MIN_COLOR_VALUE = 50
local MAX_COLOR_VALUE = 200
local HIGHLIGHT_PRIORITY = 100

-- Function to generate a random color (but not too bright)
function HighlightManager.generate_random_color()
  local r = math.random(MIN_COLOR_VALUE, MAX_COLOR_VALUE)
  local g = math.random(MIN_COLOR_VALUE, MAX_COLOR_VALUE)
  local b = math.random(MIN_COLOR_VALUE, MAX_COLOR_VALUE)
  return string.format("%02X%02X%02X", r, g, b)
end

-- Highlight a custom pattern or the word under the cursor
function HighlightManager.highlight_pattern(pattern)
  pattern = pattern or vim.fn.expand("<cword>")
  if pattern == "" then
    print("No word found under the cursor.")
    return
  end

  HighlightManager.nbhighlight = HighlightManager.nbhighlight + 1
  local group = 'custom' .. HighlightManager.nbhighlight
  local bgcolor = HighlightManager.generate_random_color()

  local match_id = vim.fn.matchadd(group, '\\<' .. pattern .. '\\>', HIGHLIGHT_PRIORITY)
  if match_id ~= 0 then
    vim.cmd('highlight ' .. group .. ' guibg=#' .. bgcolor .. ' guifg=#' .. HighlightManager.fgcolor)
    table.insert(HighlightManager.highlight_ids, match_id)
  else
    print("Failed to add match for pattern: " .. pattern)
  end
end

-- Create a custom Ex-command to highlight a given pattern
vim.api.nvim_create_user_command(
  'HighlightPattern',
  function(opts)
    HighlightManager.highlight_pattern(opts.args)
  end,
  { nargs = 1, desc = 'Highlight a custom pattern' }
)

-- Delete all highlights
function HighlightManager.delete_all_highlights()
  for _, match_id in ipairs(HighlightManager.highlight_ids) do
    pcall(vim.fn.matchdelete, match_id)
  end
  HighlightManager.highlight_ids = {}
end

-- Define keymaps for highlighting and deleting highlights
vim.keymap.set({ 'n' }, '<leader>hw', function() HighlightManager.highlight_pattern() end, { desc = 'Highlight word' })
vim.keymap.set({ 'n' }, '<leader>hd', function() HighlightManager.delete_all_highlights() end, { desc = 'Delete all highlights' })


-- Function to get the selected text in visual mode
local function get_visual_selection()
  vim.cmd.normal { vim.fn.mode(), bang = true }
  local vstart = vim.fn.getpos("'<")
  local vend = vim.fn.getpos("'>")
  return table.concat(vim.fn.getregion(vstart, vend), "\n")
end

-- Define a keymap for visual mode to highlight the selected text
vim.keymap.set({ 'v' }, '<leader>hs', function()
  -- Get the selected text in visual mode
  local selected_text = get_visual_selection()
  -- Call the highlight_pattern function with the selected text
  HighlightManager.highlight_pattern(selected_text)
end, { desc = 'Highlight selected text' })


