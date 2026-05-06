-- Pull in the wezterm API
local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
modal.apply_to_config(config)

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end


-- This is where you actually apply your config choices

-- Colorscheme used 
-- config.color_scheme = 'Tokyo Night Moon'
config.color_scheme = 'OneDark (base16)'

-- shell to open
-- config.default_domain = 'WSL:Debian'

-- Delete window pane
config.window_decorations = "RESIZE"

-- Font size 
config.font_size = 12

-- How many lines of scrollback you want to retain per tab
config.scrollback_lines = 5000

config.colors = {
    -- the foreground color of selected text
    selection_fg = 'black',
    -- the background color of selected text
    selection_bg = '#fffacd',

    -- Colors for copy_mode and quick_select
    -- available since: 20220807-113146-c2fee766
    -- In copy_mode, the color of the active text is:
    -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
    -- 2. selection_* otherwise
    copy_mode_active_highlight_bg = { Color = 'black' },
    -- use `AnsiColor` to specify one of the ansi color palette values
    -- (index 0-15) using one of the names "Black", "Maroon", "Green",
    --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
    -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
    copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
    copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
    copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

    quick_select_label_bg = { Color = 'peru' },
    quick_select_label_fg = { Color = 'White' },
    quick_select_match_bg = { AnsiColor = 'Navy' },
    quick_select_match_fg = { Color = 'White' },

    tab_bar = {
        -- The color of the strip that goes along the top of the window
        -- (does not apply when fancy tab bar is in use)
        background = '#0b0022',

        -- The active tab is the one that has focus in the window
        active_tab = {
            -- The color of the background area for the tab
            bg_color = '#2b2042',
            -- The color of the text for the tab
            fg_color = '#c0c0c0',

            -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
            -- label shown for this tab.
            -- The default is "Normal"
            intensity = 'Normal',

            -- Specify whether you want "None", "Single" or "Double" underline for
            -- label shown for this tab.
            -- The default is "None"
            underline = 'None',

            -- Specify whether you want the text to be italic (true) or not (false)
            -- for this tab.  The default is false.
            italic = false,

            -- Specify whether you want the text to be rendered with strikethrough (true)
            -- or not for this tab.  The default is false.
            strikethrough = false,
        },

        -- Inactive tabs are the tabs that do not have focus
        inactive_tab = {
            bg_color = '#1b1032',
            fg_color = '#808080',

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `inactive_tab`.
        },

        -- You can configure some alternate styling when the mouse pointer
        -- moves over inactive tabs
        inactive_tab_hover = {
            bg_color = '#3b3052',
            fg_color = '#909090',
            italic = true,

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `inactive_tab_hover`.
        },

        -- The new tab button that let you create new tabs
        new_tab = {
            bg_color = '#1b1032',
            fg_color = '#808080',

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `new_tab`.
        },

        -- You can configure some alternate styling when the mouse pointer
        -- moves over the new tab button
        new_tab_hover = {
            bg_color = '#3b3052',
            fg_color = '#909090',
            italic = true,

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `new_tab_hover`.
        },
    },
}

config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
}

config.keys = {
    -- QuickSelect for all word chunks
    {
      key = 'A',
      mods = 'CTRL',
      action = wezterm.action.QuickSelectArgs {
        patterns = {
          '\\S+',
        },
      },
    },
    -- QuickSelect for all block chunks
    {
        key = 'Q',
        mods = 'CTRL',
        action = wezterm.action.QuickSelectArgs {
          patterns = {
            '\\w+',
          },
        },
      },
    -- QuickSelect for all line chunk
    {
        key = 'Z',
        mods = 'CTRL',
        action = wezterm.action.QuickSelectArgs {
        patterns = {
            '\\S.+',
        },
        },
    },


    {
      key = 'h',
      mods = 'CTRL|SHIFT|',
      action = act.ActivatePaneDirection 'Left',
    },
    {
        key = 'l',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Right',
    },
    {
        key = 'k',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Up',
    },
    {
        key = 'j',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Down',
    },

    -- This will create a new split and run the `top` program inside it
    {
        key = '3',
        mods = 'CTRL|SHIFT|ALT',
        action = wezterm.action.SplitVertical {
        },
    },
    -- This will create a new split and run the `top` program inside it
    {
        key = '%',
        mods = 'CTRL|SHIFT|ALT',
        action = wezterm.action.SplitHorizontal {
        },
    },


  }

if package.config:sub(1,1) == '/' then
    wezterm.on('trigger-vim-with-scrollback', function(window, pane)
      -- Retrieve the text from the pane
      local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

      -- Create a temporary file to pass to vim
      local name = os.tmpname()
      local f = io.open(name, 'w+')
      f:write(text)
      f:flush()
      f:close()

      -- Open a new window running vim and tell it to open the file
      window:perform_action(
        act.SpawnCommandInNewWindow {
          args = { 'nvim', name },
        },
        pane
      )

      -- Wait "enough" time for vim to read the file before we remove it.
      -- The window creation and process spawn are asynchronous wrt. running
      -- this script and are not awaitable, so we just pick a number.
      --
      -- Note: We don't strictly need to remove this file, but it is nice
      -- to avoid cluttering up the temporary directory.
      wezterm.sleep_ms(1000)
      os.remove(name)
    end)

    -- Add mapping to mapping list
    table.insert(config.keys,
    {
        key = 'E',
        mods = 'CTRL',
        action = act.EmitEvent 'trigger-vim-with-scrollback',
    })
else
end

-- and finally, return the configuration to wezterm
return config

