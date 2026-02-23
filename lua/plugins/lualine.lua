--- @type LazySpec
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.opt.laststatus = 0
  end,
  opts = function()
    local palette = require("daltonkyemiller.colors").miasma
    local noice_ok, noice_api = pcall(require, "noice.api")

    local colors = {
      bg = palette.palette.bg,
      bg_dark = palette.palette.bg_dark,
      fg = palette.palette.fg,
      comment = palette.palette.comment,
      green = palette.palette.green,
      yellow = palette.palette.yellow,
      orange = palette.palette.orange,
      red = palette.palette.red,
      olive = palette.palette.olive,
      brown = palette.palette.brown,
    }

    local mode_color = {
      n = { bg = colors.green, fg = colors.bg },
      i = { bg = colors.olive, fg = colors.bg },
      v = { bg = colors.brown, fg = colors.fg },
      [""] = { bg = colors.brown, fg = colors.fg },
      V = { bg = colors.brown, fg = colors.fg },
      c = { bg = colors.yellow, fg = colors.bg },
      no = { bg = colors.green, fg = colors.bg },
      s = { bg = colors.orange, fg = colors.bg },
      S = { bg = colors.orange, fg = colors.bg },
      [""] = { bg = colors.orange, fg = colors.bg },
      ic = { bg = colors.olive, fg = colors.bg },
      R = { bg = colors.red, fg = colors.bg },
      Rv = { bg = colors.red, fg = colors.bg },
      cv = { bg = colors.yellow, fg = colors.bg },
      ce = { bg = colors.yellow, fg = colors.bg },
      r = { bg = colors.yellow, fg = colors.bg },
      rm = { bg = colors.yellow, fg = colors.bg },
      ["r?"] = { bg = colors.yellow, fg = colors.bg },
      ["!"] = { bg = colors.red, fg = colors.bg },
      t = { bg = colors.green, fg = colors.bg },
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 70
      end,
    }

    local config = {
      options = {
        component_separators = "",
        section_separators = "",
        theme = {
          normal = { c = { fg = colors.fg, bg = colors.bg } },
          inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
        globalstatus = true,
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
      tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    }

    local function active_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    local function active_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    local function inactive_left(component)
      table.insert(config.inactive_sections.lualine_c, component)
    end

    local function tabline_left(component)
      table.insert(config.tabline.lualine_c, component)
    end

    -- Tabline: buffers
    tabline_left({
      "buffers",
      show_filename_only = true,
      hide_filename_extension = false,
      show_modified_status = true,
      mode = 0,
      max_length = vim.o.columns * 2 / 3,
      filetype_names = {
        TelescopePrompt = "Telescope",
        fzf = "FZF",
      },
      buffers_color = {
        active = { bg = colors.green, fg = colors.bg, gui = "bold" },
        inactive = { bg = colors.bg, fg = colors.comment },
      },
      symbols = {
        modified = " ●",
        alternate_file = "",
        directory = "",
      },
      separator = { left = "░▒▓", right = "▓▒░" },
    })

    -- Active left section
    active_left({
      function()
        local ok, devicons = pcall(require, "nvim-web-devicons")
        if ok then
          local icon = devicons.get_icon(vim.fn.expand("%:t"))
            or devicons.get_icon_by_filetype(vim.bo.filetype)
            or ""
          return icon:gsub("%s+", "")
        end
        return ""
      end,
      color = function()
        return mode_color[vim.fn.mode()] or mode_color.n
      end,
      padding = { left = 1, right = 1 },
      separator = { right = "▓▒░" },
    })

    active_left({
      "filename",
      cond = conditions.buffer_not_empty,
      color = function()
        return mode_color[vim.fn.mode()] or mode_color.n
      end,
      padding = { left = 1, right = 1 },
      separator = { right = "▓▒░" },
      symbols = {
        modified = "󰶻 ",
        readonly = " ",
        unnamed = " ",
        newfile = " ",
      },
    })

    active_left({
      "branch",
      icon = "",
      color = { bg = colors.brown, fg = colors.fg },
      padding = { left = 0, right = 1 },
      separator = { right = "▓▒░", left = "░▒▓" },
    })

    -- Sidekick status
    active_left({
      function()
        return " "
      end,
      color = function()
        local ok, status = pcall(function()
          return require("sidekick.status").get()
        end)
        if ok and status then
          return status.kind == "Error" and "DiagnosticError"
            or status.busy and "DiagnosticWarn"
            or "Special"
        end
      end,
      cond = function()
        local ok, status = pcall(require, "sidekick.status")
        return ok and status.get() ~= nil
      end,
    })

    -- Noice mode
    if noice_ok then
      active_left({
        noice_api.status.mode.get,
        cond = noice_api.status.mode.has,
        color = { fg = colors.yellow },
      })
    end

    -- Inactive left section
    inactive_left({
      "filename",
      cond = conditions.buffer_not_empty,
      color = { bg = colors.bg, fg = colors.comment },
      padding = { left = 1, right = 1 },
      separator = { right = "▓▒░" },
    })

    -- Active right section
    active_right({
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = { error = " ", warn = " ", info = " " },
      diagnostics_color = {
        error = { fg = colors.bg },
        warn = { fg = colors.bg },
        info = { fg = colors.bg },
      },
      color = { bg = colors.yellow, fg = colors.bg },
      padding = { left = 1, right = 1 },
      separator = { right = "▓▒░", left = "░▒▓" },
    })

    active_right({
      "location",
      color = { bg = colors.orange, fg = colors.bg },
      padding = { left = 1, right = 0 },
      separator = { left = "░▒▓" },
    })

    active_right({
      function()
        local cur = vim.fn.line(".")
        local total = vim.fn.line("$")
        return string.format("%2d%%%%", math.floor(cur / total * 100))
      end,
      color = { bg = colors.orange, fg = colors.bg },
      padding = { left = 1, right = 1 },
      cond = conditions.hide_in_width,
      separator = { right = "▓▒░" },
    })

    active_right({
      "filetype",
      cond = conditions.hide_in_width,
      color = { bg = colors.olive, fg = colors.bg },
      padding = { left = 1, right = 1 },
      separator = { right = "▓▒░", left = "░▒▓" },
    })

    return config
  end,
}
