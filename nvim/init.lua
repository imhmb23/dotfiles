-- ==============================================================================
-- LEADER KEY SETUP (Must be set before keymaps)
-- ==============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
vim.keymap.set("v", "<leader>cs", "y", { desc = "Copy selection" })
vim.keymap.set("v", "<leader>cts", "d", { desc = "Cut selection" })
vim.keymap.set("n", "<leader>sa", "ggVG", { desc = "Select all" })
vim.keymap.set("n", "<leader>aac", "ggVGy", { desc = "Select all and copy" })
vim.keymap.set("n", "<leader>aad", 'ggVG"_d', { desc = "Select all and delete" })
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

-- ==============================================================================
-- PLUGIN MANAGER & DISCORD RICH PRESENCE (lazy.nvim + cord.nvim)
-- ==============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'vyfor/cord.nvim',
    build = ':Cord update',
    opts = {
      text = {
        default = "Using Neovim", -- Fallback text
        editing = "Using Neovim", -- Hides filename when editing
        viewing = "Using Neovim", -- Hides filename when viewing
      },
    },
  },
})
