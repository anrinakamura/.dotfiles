-- fuzzy finder
return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({})

		local map = vim.keymap.set
		local opts = { silent = true, noremap = true }
		map("n", "<C-p>", fzf.files, opts) -- files
		map("n", "<C-\\>", fzf.buffers, opts) -- buffers
		map("n", "<C-g>", fzf.grep, opts) -- grep
		map("n", "<C-l>", fzf.live_grep, opts) -- live grep
		map("n", "<C-k>", fzf.builtin, opts) -- fzf-lua builtins
		map("n", "<F1>", fzf.help_tags, opts) -- help
	end,
}
