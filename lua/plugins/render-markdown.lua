---@type LazySpec
return {
  "MeanderingProgrammer/render-markdown.nvim",
  init = function()
    local palette = require("daltonkyemiller.colors"):get_palette()
    local color1_bg = palette.dragonRed
    local color2_bg = palette.dragonOrange
    local color3_bg = palette.dragonYellow
    local color4_bg = palette.dragonGreen
    local color5_bg = palette.dragonBlue
    local color6_bg = palette.dragonPurple

    local color_fg = "#191724"

    -- vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s]], color_fg, color1_bg))
    -- vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s]], color_fg, color2_bg))
    -- vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s]], color_fg, color3_bg))
    -- vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s]], color_fg, color4_bg))
    -- vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s]], color_fg, color5_bg))
    -- vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s]], color_fg, color6_bg))

    -- Highlight for the heading and sign icons (symbol on the left)
    -- I have the sign disabled for now, so this makes no effect
    -- vim.cmd(string.format([[highlight Headline1Fg cterm=bold gui=bold guifg=%s]], color1_bg))
    -- vim.cmd(string.format([[highlight Headline2Fg cterm=bold gui=bold guifg=%s]], color2_bg))
    -- vim.cmd(string.format([[highlight Headline3Fg cterm=bold gui=bold guifg=%s]], color3_bg))
    -- vim.cmd(string.format([[highlight Headline4Fg cterm=bold gui=bold guifg=%s]], color4_bg))
    -- vim.cmd(string.format([[highlight Headline5Fg cterm=bold gui=bold guifg=%s]], color5_bg))
    -- vim.cmd(string.format([[highlight Headline6Fg cterm=bold gui=bold guifg=%s]], color6_bg))
  end,
  opts = function()
    local icons = require("nvim-nonicons")

    --- @type render.md.UserConfig
    return {
      callout = {
        note = { raw = "[!NOTE]", rendered = icons.get("note") .. " Note" },
        tip = { raw = "[!TIP]", rendered = icons.get("light-bulb") .. " Tip" },
        important = { raw = "[!IMPORTANT]", rendered = icons.get("comment") .. " Important" },
        warning = { raw = "[!WARNING]", rendered = icons.get("alert") .. " Warning" },
        caution = { raw = "[!CAUTION]", rendered = icons.get("stop") .. " Caution" },
        abstract = { raw = "[!ABSTRACT]", rendered = icons.get("note") .. " Abstract" },
        summary = { raw = "[!SUMMARY]", rendered = icons.get("note") .. " Summary" },
        tldr = { raw = "[!TLDR]", rendered = icons.get("note") .. " TL;DR" },
        info = { raw = "[!INFO]", rendered = icons.get("info") .. " Info" },
        todo = { raw = "[!TODO]", rendered = icons.get("tasklist") .. " Todo" },
        hint = { raw = "[!HINT]", rendered = icons.get("lightbulb") .. " Hint" },
        success = { raw = "[!SUCCESS]", rendered = icons.get("check") .. " Success" },
        check = { raw = "[!CHECK]", rendered = icons.get("check") .. " Check" },
        done = { raw = "[!DONE]", rendered = icons.get("check") .. " Done" },
        question = { raw = "[!QUESTION]", rendered = icons.get("question") .. " Question" },
        help = { raw = "[!HELP]", rendered = icons.get("question") .. " Help" },
        faq = { raw = "[!FAQ]", rendered = icons.get("question") .. " FAQ" },
        attention = { raw = "[!ATTENTION]", rendered = icons.get("alert") .. " Attention" },
        failure = { raw = "[!FAILURE]", rendered = icons.get("stop") .. " Failure" },
        fail = { raw = "[!FAIL]", rendered = icons.get("stop") .. " Fail" },
        missing = { raw = "[!MISSING]", rendered = icons.get("circle-slash") .. " Missing" },
        danger = { raw = "[!DANGER]", rendered = icons.get("stop") .. " Danger" },
        error = { raw = "[!ERROR]", rendered = icons.get("stop") .. " Error" },
        bug = { raw = "[!BUG]", rendered = icons.get("bug") .. " Bug" },
        example = { raw = "[!EXAMPLE]", rendered = icons.get("note") .. " Example" },
        quote = { raw = "[!QUOTE]", rendered = icons.get("quote") .. " Quote" },
        cite = { raw = "[!CITE]", rendered = icons.get("quote") .. " Cite" },
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        checked = {
          icon = " ",
        },
        unchecked = {
          icon = " ",
        },
      },
      link = {
        hyperlink = icons.get("link") .. " ",
        image = icons.get("image") .. " ",
        custom = {
          web = { icon = icons.get("link") .. " ", highlight = "RenderMarkdownLink" },
        },
      },
      file_types = { "markdown", "Avante" },
      heading = {
        border = true,
        -- above = icons.get("chevron-up"),
        -- below = icons.get("chevron-down"),
        -- sign = false,
        icons = { "1 ", "2 ", "3 ", "4 ", "5 ", "6 " },
        -- backgrounds = {
        --   "Headline1Bg",
        --   "Headline2Bg",
        --   "Headline3Bg",
        --   "Headline4Bg",
        --   "Headline5Bg",
        --   "Headline6Bg",
        -- },
        -- foregrounds = {
        --   "Headline1Fg",
        --   "Headline2Fg",
        --   "Headline3Fg",
        --   "Headline4Fg",
        --   "Headline5Fg",
        --   "Headline6Fg",
        -- },
      },
    }
  end,
}
