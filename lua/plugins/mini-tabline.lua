--- @type LazySpec
return {
  "echasnovski/mini.tabline",
  enabled = false,

  opts = {
    -- Whether to show file icons (requires 'mini.icons')
    show_icons = true,

    -- Function which formats the tab label
    -- Adds fade effect on the right edge
    format = function(_, label)
      return "▓▒░ " .. label .. " ░▒▓"
    end,

    -- Whether to set Vim's settings for tabline (make it always shown and
    -- allow hidden buffers)
    set_vim_settings = true,

    -- Where to show tabpage section in case of multiple vim tabpages.
    -- One of 'left', 'right', 'none'.
    tabpage_section = "left",
  },
}
