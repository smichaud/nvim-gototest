local M = {}

function Todo()
    print("a")
end

M.todo = Todo

-- vim.api.nvim_create_user_command("Todo", Todo, {})
-- vim.keymap.set("n", "<leader>z", Todo)

return M
