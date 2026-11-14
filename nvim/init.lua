-- ==============================================================================
-- LEADER KEY SETUP (Must be set before keymaps)
-- ==============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ==============================================================================
-- BASIC NEOVIM SETTINGS
-- ==============================================================================
-- ==============================================================================
-- BASIC NEOVIM SETTINGS
-- ==============================================================================
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Relative line numbers
vim.opt.tabstop = 4               -- 4 spaces per tab
vim.opt.shiftwidth = 4            -- Indent width
vim.opt.expandtab = true          -- Convert tabs to spaces
vim.opt.smartindent = true        -- Auto-indent new lines
vim.opt.ignorecase = true         -- Case-insensitive search
vim.opt.smartcase = true          -- Case-sensitive if uppercase used
vim.opt.clipboard = "unnamedplus" -- Sync with Windows clipboard
vim.opt.termguicolors = true      -- True color support
vim.opt.background = "dark"       -- Prevents E1568 background query & +q4D73 leak

-- Prevent Windows ConPTY / Alacritty escape sequence leaks on startup
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10

-- ==============================================================================
-- CUSTOM KEYBINDINGS (Tap Space, then press the sequence)
-- ==============================================================================
-- Copy selection (Visual mode: Space + c + s)
vim.keymap.set("v", "<leader>cs", "y", { desc = "Copy selection" })

-- Cut selection (Visual mode: Space + c + t + s)
vim.keymap.set("v", "<leader>cts", "d", { desc = "Cut selection" })

-- Select all (Normal mode: Space + s + a)
vim.keymap.set("n", "<leader>sa", "ggVG", { desc = "Select all" })

-- Select all and copy (Normal mode: Space + a + a + c)
vim.keymap.set("n", "<leader>aac", "ggVGy", { desc = "Select all and copy" })

-- Select all and delete without overwriting clipboard (Normal mode: Space + a + a + d)
vim.keymap.set("n", "<leader>aad", 'ggVG"_d', { desc = "Select all and delete" })

-- Select all and cut (Normal mode: Space + a + a + c + t)
vim.keymap.set("n", "<leader>aact", "ggVGd", { desc = "Select all and cut" })

-- ==============================================================================
-- TRANSPARENT BACKGROUND (Allows Alacritty opacity to show through)
-- ==============================================================================
local function transparent()
  local groups = {
    "Normal", "NormalNC", "NormalFloat", "SignColumn",
    "LineNr", "CursorLineNr", "EndOfBuffer", "WinSeparator",
  }
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = "none" })
  end
end

transparent()

-- Re-apply whenever a colorscheme loads, otherwise it paints the background back
vim.api.nvim_create_autocmd("ColorScheme", { callback = transparent })

-- ==============================================================================
-- STARTUP REDRAW (Clears Windows ConPTY +q4D73 artifact in Windowed mode)
-- ==============================================================================
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      vim.cmd("redraw!")
    end, 50)
  end,
})