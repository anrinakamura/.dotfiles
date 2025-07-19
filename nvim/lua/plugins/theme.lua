-- color scheme
local current = "tokyonight"

local themes = {
	tokyonight = {
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = false,
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
}

return { themes[current] }
