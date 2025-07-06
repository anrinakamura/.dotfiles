-- color scheme
local current = "catppuccin"

local themes = {
    tokyonight = {
        "folke/tokyonight.nvim",
        lazy = false, 
        priority = 1000, 
        config = function()
            require("tokyonight").setup({
                style = "night",
                transparent = true,
            }) 
            vim.cmd.colorscheme("tokyonight")
        end, 
    }, 
    catppuccin = {
        "catppuccin/nvim",
        name = "catppuccin", 
        lazy = false, 
        priority = 1000, 
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", 
                transparent_background = false,
            }) 
            vim.cmd.colorscheme("catppuccin")
        end, 
    }, 
    moonfly = {
        "bluz71/vim-moonfly-colors", 
        name = "moonfly", 
        lazy = false, 
        priority = 1000, 
        config = function()
            vim.g.moonflyCursorColor = true
            vim.g.moonflyTransparent = false
            vim.cmd.colorscheme("moonfly")
        end, 
    }, 
}

return { themes[current] }

