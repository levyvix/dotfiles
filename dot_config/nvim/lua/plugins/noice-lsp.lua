return {
	"folke/noice.nvim",
	opts = function(_, opts)
		opts.lsp.signature = {
			auto_open = { enabled = false },
		}
		opts.presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			inc_rename = false,
			lsp_doc_border = false,
		}
		opts.routes = opts.routes or {}
		table.insert(opts.routes, {
			filter = {
				event = "msg_show",
				kind = "",
			},
			opts = { skip = false },
		})
	end,
}
