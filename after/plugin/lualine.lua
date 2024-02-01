local function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

local branch = { 'branch', icons_enabled = false }

local diagnostics = {
    'diagnostics',

    -- or a function that returns a table as such:
    --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
    sources = { function()
        local status = require('lsp-status').diagnostics()
        --print(dump(status))
        return {
            error = status['errors'],
            warn = status['warnings'],
            info = status['info'],
            hint = status['hint']
        }
    end },

    -- Displays diagnostics for the defined severity types
    sections = { 'error', 'warn' },

    diagnostics_color = {
        -- Same values as the general color option can be used here.
        error = 'DiagnosticError', -- Changes diagnostics' error color.
        warn  = 'DiagnosticWarn',  -- Changes diagnostics' warn color.
        info  = 'DiagnosticInfo',  -- Changes diagnostics' info color.
        hint  = 'DiagnosticHint',  -- Changes diagnostics' hint color.
    },
    symbols = { error = '❌ ', warn = '⚠️  ', info = 'I', hint = 'H' },
    colored = false,         -- Displays diagnostics status in color if set to true.
    update_in_insert = true, -- Update diagnostics in insert mode.
    always_visible = false,  -- Show diagnostics even if there are none.
}

local lspstatus = {
    function ()
        return string.sub(require('lsp-status').status():sub(6), -50, -1)
    end,
    icons_enabled = false
}

local filename = {
    "filename",
    fmt = function(str)
        return vim.fn.expand('%')
    end
}

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'gruvbox',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { { 'mode', fmt = function(str) return string.lower(str) end } },
        lualine_b = { branch, diagnostics },
        lualine_c = { filename },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location', lspstatus }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filename },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
