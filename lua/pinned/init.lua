local popup = require("plenary.popup")

local M = {}

globals = {}

M.setup = function ()
end

-- @param text: string
function split(str, delim)
    local lines = {}
    local words = str:gmatch("([^" .. delim .. "]+)")
    for word in words do
        table.insert(lines, word)
    end
    return lines
end

function exit_visual()
    -- exit visual mode
    local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'x', false)
end

-- Gets the visually selected text and pastes it to pinned buffer
-- from my comment on the issue https://github.com/David-Kunz/gen.nvim/issues/147
-- also resets win
M.yank = function ()
    globals.text = ''
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")
    local buffer = vim.api.nvim_get_current_buf()
    if start_pos ~= nil and end_pos ~= nil then
        if start_pos[2] > end_pos[2] or
                (start_pos[2] == end_pos[2] and start_pos[3] >= end_pos[3]) then
            start_pos, end_pos = end_pos, start_pos
        end

        local lines = vim.api.nvim_buf_get_text(buffer, start_pos[2] - 1,
                start_pos[3] - 1, end_pos[2] - 1, end_pos[3], {})
        local text = ""
        for _, line in ipairs(lines) do
            text = text .. line .. "\n"
        end
        globals.text = text
    end
    globals.filetype = vim.api.nvim_get_option_value("filetype", { buf=buffer })

    local bufnr = vim.api.nvim_create_buf(false, true)
    globals.bufnr = bufnr

    exit_visual()
end

local create = function (bufnr)
    local lines = split(globals.text, '\n')
    local _, win = popup.create(bufnr, {
        title = "Pinned." ..  globals.filetype,
        line = 3,
        col = 100,
        minwidth = 60,
        minheight = #lines + 2,
        border=true,
    })
    vim.api.nvim_set_option_value("filetype", globals.filetype, { buf=bufnr })
    vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, lines)
    globals.win = win
end

M.show = function ()
    if globals.win == nil then
        M.yank()
    end
    create(globals.bufnr)
    exit_visual()
end

return M
