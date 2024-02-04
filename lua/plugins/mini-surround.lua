return {
  'echasnovski/mini.surround',
  enabled = false,
  version = false,
  config = true,
  opts = function()
    local ts_input = require('mini.surround').gen_spec.input.treesitter
    return {
      custom_surroundings = {
        t = {
          input = ts_input { outer = '@tag.outer', inner = '@tag.inner' },
        },
      },
      n_lines = 50,
      mappings = {
        add = 'S',
        delete = 'ds',
        replace = 'cs',
      },
    }
  end,
}
