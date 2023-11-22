return {
  "ckolkey/ts-node-action",
  config = function()
    local ts_node_action = require("ts-node-action")
    ts_node_action.setup({
      tsx = ts_node_action.node_actions.typescriptreact,
    })
    vim.keymap.set("n", "zI", ts_node_action.node_action, { desc = "Trigger TS Node Action" })
  end,
}
