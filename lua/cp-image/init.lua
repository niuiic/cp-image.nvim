local core = require("niuiic-core")
local utils = require("cp-image.utils")
local static = require("cp-image.static")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

local paste_image = function()
	local root_path = core.file.root_path(static.config.root_pattern)
	local default_path = static.config.path(root_path)
	vim.ui.input({ prompt = "Image path: ", default = default_path }, function(input)
		if input == nil or input == default_path then
			return
		end
		local image_info = utils.get_image_info(input)
		if image_info.dir_path == nil or image_info.file_name == nil or image_info.image_type == nil then
			vim.notify("wrong path", vim.log.levels.ERROR)
			return
		end
		if string.find(input, root_path, 1, true) == nil then
			vim.notify("wrong path", vim.log.levels.ERROR)
			return
		end
		utils.generate_image(static.config.cmd, input)
		local relative_path = string.sub(input, string.len(root_path) + 1)
		local pos = vim.api.nvim_win_get_cursor(0)
		core.text.insert(static.config.text(relative_path, image_info.file_name, image_info.image_type, input), {
			row = pos[1],
			col = pos[2],
		})
	end)
end

return {
	paste_image = paste_image,
	setup = setup,
}
