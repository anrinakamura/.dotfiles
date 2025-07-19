-- syntax highlight
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
				indent = { enable = true },
				ensure_installed = {
					"lua",
					"rust",
					"kotlin",
					"java",
					"c",
					"cpp",
					"python",
					"go",
				},
			})
		end,
	},
}
